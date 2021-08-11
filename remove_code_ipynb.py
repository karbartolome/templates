# Cómo eliminar código de un html descargado de una jupyter notebook

# 1) File > Download as html
# 2) Luego ejecutar este chunk: lo que hace es eliminar el código del html que se generó. 
# 3) Luego de ejecutar el código se puede abrir el html descargado y ahora tenemos un informe con todos los gráficos y el texto escrito pero no aparece el código. 

# Ubicación donde haya quedado almacenado el archivo que descargamos como html:
FILE = "archivo.html" #Archivo html del cual se quiere eliminar el código

with open(FILE, 'r') as html_file:
    content = html_file.read()
    
# Get rid off prompts and source code
content = content.replace("div.input_area {","div.input_area {\n\tdisplay: none;")    
content = content.replace(".prompt {",".prompt {\n\tdisplay: none;")

f = open(FILE, 'w')
f.write(content)
f.close()

# Después de ejecutar este código se puede abrir nuevamente el html y ahora no aparece el código
