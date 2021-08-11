# Cómo eliminar código de un html descargado de una jupyter notebook

# 1) File > Download as html
# 2) Luego ejecutar este chunk: lo que hace es eliminar el código del html que se generó. 
# 3) Luego de ejecutar el código se puede abrir el html descargado y ahora tenemos un informe con todos los gráficos y el texto escrito pero no aparece el código. 

# Ubicación donde haya quedado almacenado el archivo que descargamos como html:
import re

READ_FILE = "archivo.html"
WRITE_FILE = "archivo_nuevo.html"

with open(READ_FILE, 'r', encoding = 'utf8') as html_file:
    content = html_file.read()

# Get rid off prompts and source code
# content = content.replace("div.input_area {","div.input_area {\n\tdisplay: none;")    
# content = content.replace(".prompt {",".prompt {\n\tdisplay: none;")
content = content.replace("jp-InputArea {","jp-InputArea {\n\tdisplay: none;")    
# content = content.replace("jp-OutputArea-prompt\">Out[4]: {","-prompt {\n\tdisplay: none;")
content = re.sub(r'>Out\[\d{1,5}]:<', '><', content)
# jp-OutputArea-prompt">Out[4]:

f = open(WRITE_FILE, 'w', encoding = 'utf8')
f.write(content)
f.close()

# Después de ejecutar este código se puede abrir nuevamente el html y ahora no aparece el código
