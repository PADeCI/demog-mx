![Build Status](https://img.shields.io/github/issues/PADeCI/covid19-mx-data)
![Build Status](https://img.shields.io/github/forks/PADeCI/covid19-mx-data)
![Build Status](https://img.shields.io/github/stars/PADeCI/covid19-mx-data)
![Build Status](https://img.shields.io/github/license/PADeCI/covid19-mx-data)
![Build Status](https://img.shields.io/twitter/url?style=social)

<p align="center">
<img src = "https://github.com/PADeCI/demog-mx/blob/master/logo.png" alt="logo" width="200"/>
</p>  

_____
# VERSIÓN EN ESPAÑOL: Datos demográficos de México

# Sobre este repositorio :open_book:
[PADeCI](https://twitter.com/PADeCI1) es un equipo de investigación interdisciplinario ubicado en el [CIDE Región Centro](https://www.facebook.com/cideregioncentro) en Aguascalientes, México. Con el contenido de este repostiorio se construyen diversas bases de datos de información demográfica de México, necesaria para los diferentes proyectos de PADeCI. Las series de tiempo poblacionales se construyen a partir de la información pública del Consejo Nacional de Población (Conapo). Gracias a las proyecciones realizadas por el Conapo, se cuenta con información desde 1950, hasta el año 2051. Además de la población en un año específico, también se incluyen proyecciones para el número de nacimientoss y número de muertes. Hay bases para diferentes necesidades: desagregadas a nivel estatal, a nivel municipal, para la Zona Metropolitana del Valle de México (ZMVM); desagregadas por género y edad. Las personas interesadas pueden utilizar los datos ofrecidos en este repositorio para cualquiera de sus proyectos profesionales o personales. Además de ser una herramienta de investigación, el respositorio también abre la oportunidad a que cualquier persona replique el proceso de limpieza y generación de datos hecho por PADeCI, siguiendo así los principios científicos de _transparencia_ y _replicabilidad_.

# Requisitos :computer:
R version 3.6.2 (ésta es la versión recomendada para evitar errores en el código, también conocidos como _bugs_). 

# Uso :inbox_tray:
Cualquier persona puede replicar el trabajo de PADeCI, ya sea clonando este repositorio en su computadora o descargando archivos específicos. Los datos también se pueden utilizar sin necesidad de descargar, ni clonar el respositorio: basta con utilizar el url que GitHub provee de la base de datos específica que se desea utilizar en formato raw, a continuación se presenta un ejemplo de cómo acceder a los datos usando este método.

## Ejemplo de uso de los datos (extracción directa con url de GitHub desde R)
1. Seleccionar la base de interés 
El repositorio incluye numerosas bases de datos (más detalles en la sección de análisis en el apartado de descripción de las carpetas). En este caso utilizaremos la base de número de nacimientos anual desagreados por entidad federativa. 

2. Obtener la url para el formato raw de la base de datos 
Una vez seleccionada la base que se utilizará, es necesario abrirla en formato raw y copiar el url que aparece en el navegador. 

<p align="center">
<img src = "https://github.com/PADeCI/demog-mx/blob/master/tutorial_demog1.1.png" alt="logo" width="700"/>
</p> 



<p align="center">
<img src = "https://github.com/PADeCI/demog-mx/blob/master/tutorial_demog2.1.png" alt="logo" width="700"/>
</p> 


3. Importar base de datos directo de la url 
Se usa el siguiente comando para crear el objeto en R que contendrá la base, nótese que utiliza el url de la base tipo raw de GitHub del paso anterior. 

```r
mi_base <- read.csv("https://raw.githubusercontent.com/PADeCI/demog-mx/master/data/Estatal/df_birth_state.csv?token=AMIIVUKSWRAUEVCJQPGC5TK66YVHC")
```
4. Explorar datos
Para una exploración rápida de la base se puede utilizar el comando `head()` y para ver toda la base el comando `View()`. En este ejemplo sería: 

```r
head(mi_base) 
View(mi_base) 
```
A partir de este punto la persona puede decidir qué hacer con los datos y proceder a realizar su propio análisis. 


# Descripción de las carpetas :card_index_dividers:
**1. R:** En esta carpeta se ubica un archivo de código en R en el cual se crean dos funciones necesarias para el modelo demográfico no homogéneo.  

**2. analysis:** En la carpeta de análisis se encuentran los archivos de código en R que se encargan de la limpieza de datos, las proyecciones demográficas, la creación del modelo y la verificación de que los datos sean consistentes entre sí y con las cifras oficiales.

**3. data-raw:** La carpeta de datos crudos incluye las diferentes bases de datos en formato csv publicadas por el Conapo, la información detallada sobre estas bases se encuentra en la carpeta de documentos.

**4. data:** En la carpeta de datos se almacenan las bases de datos de formato R producto de los procesos de limpieza y modelación que se realiza con los códigos contenidos en la carpeta de análisis. Las diferentes bases de datos son posibles combinaciones de las siguientes características:

- Variables demográfica
  - Número de habitantes (población)  
  - Número de nacimientos 
  - Número de muertes 
  
- Niveles para desagregado 
  - Estatal (incluye datos nacionales) 
  - Municipal 
  - Zona Metropolitana del Valle de México (ZMVM) 
  
- Variables de caracterísitcas personales 
  - Género 
  - Edad
  
**5. documents:** La carpeta de documentos incluye los diccionarios de datos y fichas técnicas de Conapo sobre las bases de datos que son la fuente de información para este proyecto. 

# Cómo citar este respositorio :handshake:
En caso de utilizar los datos de este repositorio, favor de referenciar el trabajo de la siguiente manera: (Aquí se agregará el DOI generado por Zenodo) 

# Autoras y autores :writing_hand:
Fernando Alarid-Escudero   | [GitHub](https://github.com/feralaes) | [Twitter](https://twitter.com/feralaes) |
------------ | ------------- | -------------
Andrea Luviano             | [GitHub](https://github.com/AndreaLuviano) | [Twitter](https://twitter.com/AndreaLuviano)
Regina Isabel Medina       | [GitHub](https://github.com/RMedina19) | [Twitter](https://twitter.com/regi_medina) |
Hirvin Díaz                | [GitHub](https://github.com/HirvinDiaz) | [Twitter](https://twitter.com/HazaelDiaz93) |

# Licencia de uso :scroll:
El contenido de este repositorio debe utilizarse bajo las condiciones de la [licencia MIT](LICENSE).

_____

# ENGLISH VERSION: Mexico's demographic data
# About this repository :open_book:
[PADeCI](https://twitter.com/PADeCI1) is an interdisciplinary research team based at [CIDE Región Centro](https://www.facebook.com/cideregioncentro) in Aguascalientes, Mexico. With this repository's content several data bases with Mexico's demographic information are constructed. This informatión is needed for many of PADeCI's projects. Population time serires are constructed with public information provided by the National Population Data (Conapo, spanish acronym). Thanks to mathematical projections, the data bases contain information from 1950 to 2051. Besides the population on a given year, there are also projections concerning the number of births and deaths. There are data bases for different needs: state level, county level, Mexico City Metropolitan Area (MCMA) level; disaggregated by sex and age. Following the scientific principle of _transparency_, any person can replicate the cleaning process done by PADeCI's team using the contents of this repository.

# Requirements :computer:
R version 3.6.2 (this version is recommended to avoid potential bugs.) 

# Usage :inbox_tray:
Any user can either clone this repository in its own computer or download specific files in order to replicate PADeCI's job.It suffices with using the url of the raw format provided by GitHub of the data base of interest. A quick example of how to retrive data with the last method is shown below. 

## Use example (extracting data with GitHub's url from R)
1. Select data base of interest
The repository includes several data bases (more detail can be found in the analysis subsection in the folder's description section). In this case, we will use the data base for anual births dissagregated by state level. 

2. Get the GitHub's url for the raw format of the data base
Once the data base is chosen, it is necessary to open the raw format provided by GitHub and copy the url from the web navigator.

<p align="center">
<img src = "https://github.com/PADeCI/demog-mx/blob/master/tutorial_demog1.1.png" alt="logo" width="700"/>
</p> 



<p align="center">
<img src = "https://github.com/PADeCI/demog-mx/blob/master/tutorial_demog2.1.png" alt="logo" width="700"/>
</p> 


3. Import data base directly from the url 
The following command is used to create and R object that will contain the data base, the GitHub's url retrived in the last step must be used.

```r
my_data <- read.csv("https://raw.githubusercontent.com/PADeCI/demog-mx/master/data/Estatal/df_birth_state.csv?token=AMIIVUKSWRAUEVCJQPGC5TK66YVHC")
```
4. Explor data
For a quick data exploration, the `head()` command  can be used; in order to see the whole data frame, `View()` command must be used. Following our example:

```r
head(my_data) 
View(my_data) 
```
At this stage, the person can decide what to do with data and proceed with her own analysis. 

# Folders' description :card_index_dividers:
**1. R:**  This folder stores a single R script that contains two functions needed for the non-homogeneous model. 

**2. analysis:** The analysis folder contains R script files that manage data wrangling, demographic projections, modeling and verification for consistency among scripts themselves and official data. 

**3. data-raw:** This folder includes several Conapo's data bases in csv format, detailed information of this data bases can be found in the documents folder. 

**4. data:** The data foler has R data bases that are produced from wrangling and modeling scripts, which can be found at the analysis folder. Different data bases are combinations from the following characteristics: 
- Demographic variables 
  - Number of inhabitants (population) 
  - Number of births 
  - Number of deaths 
  
- Dissagregation levels 
  - State (includes national data) 
  - County 
  - Mexico City Metropolitan Area (MCMA)
  
- Personal characteristic variables
  - Gender
  - Age

**5. documents:** This folder contains Conapo's data dictionaries and technical reports regarding their data bases which constitute the primary source of information for this project. 

# How to cite this repository :handshake:
In case of using the respository's data, please cite the work using the following format: (Insert Zenodo's DOI link)  

# Authors :writing_hand:
Fernando Alarid-Escudero   | [GitHub](https://github.com/feralaes) | [Twitter](https://twitter.com/feralaes) |
------------ | ------------- | -------------
Andrea Luviano             | [GitHub](https://github.com/AndreaLuviano) | [Twitter](https://twitter.com/AndreaLuviano)
Regina Isabel Medina       | [GitHub](https://github.com/RMedina19) | [Twitter](https://twitter.com/regi_medina) |
Hirvin Díaz                | [GitHub](https://github.com/HirvinDiaz) | [Twitter](https://twitter.com/HazaelDiaz93) |

# License :scroll:
This repository's content must be used under the terms and conditions of the [MIT License](LICENSE)

________

# Nota metodológica | Methology note :world_map:
Lista de municipios que constituyen la Zona Metropolinata del Valle de México (ZMVM) | List of counties that constitute the Mexico City Metropolitan Area (MCMA) 
- Azcapotzalco
- Coyoacán
- Cuajimalpa De Morelos
- Gustavo A. Madero
- Iztacalco
- Iztapalapa
- La Magdalena Contreras
- Milpa Alta
- Álvaro Obregón
- Tláhuac
- Tlalpan
- Xochimilco
- Benito Juárez
- Cuauhtémoc
- Miguel Hidalgo
- Venustiano Carranza
- Tizayuca
- Acolman
- Amecameca
- Apaxco
- Atenco
- Atizapán De Zaragoza
- Atlautla
- Axapusco
- Ayapango
- Coacalco De Berriozábal
- Cocotitlán
- Coyotepec
- Cuautitlán
- Chalco
- Chiautla
- Chicoloapan
- Chiconcuac
- Chimalhuacán
- Ecatepec De Morelos
- Ecatzingo
- Huehuetoca
- Hueypoxtla
- Huixquilucan
- Isidro Fabela
- Ixtapaluca
- Jaltenco
- Jilotzingo
- Juchitepec
- Melchor Ocampo
- Naucalpan De Juárez
- Nezahualcóyotl
- Nextlalpan
- Nicolás Romero
- Nopaltepec
- Otumba
- Ozumba
- Papalotla
- La Paz
- San Martín De Las Pirámides
- Tecámac
- Temamatla
- Temascalapa
- Tenango Del Aire
- Teoloyucan
- Teotihuacán
- Tepetlaoxtoc
- Tepetlixpa
- Tepotzotlán
- Tequixquiac
- Texcoco
- Tezoyuca
- Tlalmanalco
- Tlalnepantla De Baz
- Tultepec
- Tultitlán
- Villa Del Carbón
- Zumpango
- Cuautitlán Izcalli
- Valle De Chalco Solidaridad
- Tonanitla
