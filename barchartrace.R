library(gganimate)
library(tidyverse)
library(ggimage)
library(ggplot2)

#datos ej
data <- read_csv('https://gist.githubusercontent.com/johnburnmurdoch/2e5712cce1e2a9407bf081a952b85bac/raw/08cf82f5e03c619f7da2700d1777da0b5247df18/INTERBRAND_brand_values_2000_2018_decimalised.csv')

data2<-data %>% filter(data$name %in% c("Apple","Microsoft","Google","Amazon") & data$year >=2012.1)

data2 <- data2 %>% mutate(imagen=case_when(
  name=="Google" ~ "https://s5.eestatic.com/2015/10/03/actualidad/Actualidad_68753203_129196255_1024x576.jpg",
  name=="Microsoft" ~ "https://upload.wikimedia.org/wikipedia/commons/thumb/4/44/Microsoft_logo.svg/1024px-Microsoft_logo.svg.png",
  name=="Amazon" ~ "https://www.eluniversal.com.mx/sites/default/files/2019/07/12/amazon.jpg",
  name=="Apple" ~ "https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/1200px-Apple_logo_black.svg.png"
))

p<-data2 %>% group_by(year) %>% arrange(desc(value)) %>% mutate(rank=row_number())%>% 
  ggplot(
    aes(x = rank, y = value, label = name,
      group = name,
      fill = value
    ))+
  geom_tile(aes(y = value/2, 
      height = value,
      width = 0.9,
      fill = value 
    ), 
    alpha = 0.8, show.legend = TRUE)+
  scale_fill_viridis_c()+
  geom_text(aes(label = name),colour = "black", fontface = "bold",
    hjust = -0.5,
    nudge_y = 1,
    size = 3.4
  ) +
  geom_image(aes(image=imagen),size=0.1)+
  coord_flip(clip = "off", expand = FALSE) +
  scale_x_discrete("") +
  scale_y_continuous("",labels=scales::comma)+
  theme(panel.grid.major.y=element_blank(),
        panel.grid.minor.x=element_blank(),
        plot.title= element_text(size=20,colour="grey50",face="bold"),
        plot.caption = element_text(colour="grey50"),
        plot.subtitle = element_text(size=20,colour="grey50",face="bold"),
        plot.margin = margin(1,1,1,2,"cm"),
        axis.text.y=element_blank())+
  transition_time(year) +
  labs(title="title",
       subtitle='{round(frame_time,0)}',
       caption="caption")

animate(p, nframes = 100, fps = 5, end_pause = 20)

anim_save("animacion.gif", animation = last_animation())











