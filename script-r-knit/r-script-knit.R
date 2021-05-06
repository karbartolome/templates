#' ---
#' title: "Script knitteado"
#' output: github_document
#' ---
#'
#'
#+ echo=TRUE, fig.width=7, message=FALSE
library(dplyr)
library(biscale)
library(ggplot2)
library(cowplot)
library(stringr)
library(sf)
library(gt)

# Datos cajeros
df <- read.csv('https://cdn.buenosaires.gob.ar/datosabiertos/datasets/cajeros-automaticos/cajeros-automaticos.csv')
df %>% head(2) %>% gt() %>% tab_header('Cajeros automáticos en CABA')

#+ echo=TRUE, fig.width=7, message=FALSE
# Mapa barrios CABA
caba <- st_read('http://cdn.buenosaires.gob.ar/datosabiertos/datasets/barrios/barrios.geojson') %>% 
  mutate(barrio=str_to_title(barrio)) 

# Cantidad de cajeros por barrio
df_barrios <- df %>% filter(localidad=='CABA') %>% 
  group_by(barrio, red) %>% 
  summarise(n=n()) %>% 
  ungroup() %>%
  filter(barrio!='') %>% 
  tidyr::pivot_wider(names_from=red, values_from=n) %>% 
  mutate(BANELCO = tidyr::replace_na(BANELCO,0), 
         LINK = tidyr::replace_na(LINK,0))

df_barrios <- merge(caba, df_barrios, by='barrio', all.x=TRUE, all.y=TRUE)

data_biscale <- bi_class(df_barrios, 
                         x='LINK',
                         y='BANELCO', 
                         style="quantile",dim=3)

# Mapa con biscale
mapa <- ggplot() +
  geom_sf(data = data_biscale, 
          mapping = aes(fill = bi_class), 
          color = "white", 
          size = 0.1, 
          show.legend = FALSE) +
  bi_scale_fill(pal = "DkBlue", dim = 3) +
  labs(title = "Cajeros automáticos",
       subtitle = "Cantidad de cajeros por red y barrio de CABA", 
       caption = "Fuente:Gobierno de la Ciudad de Buenos Aires") +
  bi_theme()+
  theme(plot.caption = element_text(hjust = 0.2))

# Legend
legend <- bi_legend(pal = "DkBlue",
                    dim = 3,
                    xlab = "LINK",
                    ylab = "BANELCO",
                    size = 8)

#+ echo=TRUE, fig.width=10, message=FALSE
ggdraw() +
  draw_plot(mapa, 0, 0, 1, 1) +
  draw_plot(legend, 0.63, 0.05, 0.2, 0.2)



# Cantidad de cajeros por banco
df %>% 
  group_by(banco, red) %>% 
  summarise(n=n()) %>% 
  ungroup() %>% 
  slice_max(n, n=10) %>% 
  ggplot(aes(x=reorder(banco,n),y=n, fill=red))+
  geom_col()+
  coord_flip()+
  scale_fill_manual(values=c('orchid3','turquoise3'))+
  labs(title='Cantidad de cajeros automáticos por banco', 
       subtitle='Datos del GCBA', x='Banco',y='Cantidad de cajeros')+
  theme_minimal()