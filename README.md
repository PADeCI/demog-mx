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
[PADeCI](https://twitter.com/PADeCI1) es un equipo de investigación interdisciplinario ubicado en Aguascalientes, México. Con el contenido de este repostiorio se construyen diversas bases de datos de información demográfica de México, necesaria para los diferentes proyectos de PADeCI. Las series de tiempo poblacionales se construyen a partir de la información pública del Consejo Nacional de Población (Conapo). Gracias a las proyecciones realizadas por el Conapo, se cuenta con información desde 1950, hasta el año 2051. Además de la población en un año específico, también se incluyen proyecciones para el número de nacimientoss y número de muertes. Hay bases para diferentes necesidades: desagregadas a nivel estatal, a nivel municipal, para la Zona Metropolitana del Valle de México (ZMVM); desagregadas por género y edad. Siguiendo el principio científico de _transparencia_, cualquier persona interesada puede replicar el proceso de limpieza y modelación de datos hecho por el equipo de PADeCI, usando el contenido de este repositorio.

# Requisitos :computer:
R version 3.6.2 (ésta es la versión recomendada para evitar errores en el código, también conocidos como _bugs_). 

# Uso :inbox_tray:
Cualquier persona puede replicar el trabajo de PADeCI, ya sea clonando este repositorio en su computadora o descargando archivos específicos. 

# Descripción de las carpetas :card_index_dividers:
**1. R:** En esta carpeta se ubica un archivo de código en R en el cual se crean dos funciones necesarias para el modelo demográfico no homogéneo.  

**2. analysis:** En la carpeta de análisis se encuentran los archivos de código en R que se encargan de la limpieza de datos, las proyecciones demográficas, la creación del modelo y la verificación de que los datos sean consistentes entre sí y con las cifras oficiales.

**3. data-raw:** La carpeta de datos crudos incluye las diferentes bases de datos en formato csv publicadas por el Conapo, la información detallada sobre estas bases se encuentra en la carpeta de documentos.

**4. data:** En la carpeta de datos se almacenan las bases de datos de formato R producto de los procesos de limpieza y modelación que se realiza con los códigos contenidos en la carpeta de análisis. Las diferentes bases de datos son posibles combinaicones de las siguientes características:

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

# Autoras y autores :writing_hand:
Fernando Alarid-Escudero   | [GitHub](https://github.com/feralaes) | [Twitter](https://twitter.com/feralaes) |

Andrea Luviano             | [GitHub](https://github.com/AndreaLuviano) | [Twitter](https://twitter.com/AndreaLuviano)

Regina Isabel Medina       | [GitHub](https://github.com/RMedina19) | [Twitter](https://twitter.com/regi_medina) |

Hirvin Díaz                | [GitHub](https://github.com/HirvinDiaz) | [Twitter](https://twitter.com/HazaelDiaz93) |

_____

# ENGLISH VERSION: Mexico's demographic data
# About this repository :open_book:
[PADeCI](https://twitter.com/PADeCI1) is an interdisciplinary research team based in Aguascalientes, Mexico. With this repository's content several data bases with Mexico's demographic information are constructed. This informatión is needed for many of PADeCI's projects. Population time serires are constructed with public information provided by the National Population Data (Conapo, spanish acronym). Thanks to mathematical projections, the data bases contain information from 1950 to 2051. Besides the population on a given year, there are also projections concerning the number of births and deaths. There are data bases for different needs: state level, county level, Mexico City Metropolitan Area (MCMA) level; disaggregated by sex and age. Following the scientific principle of _transparency_, any person can replicate the cleaning process done by PADeCI's team using the contents of this repository.

# Requirements :computer:
R version 3.6.2 (this version is recommended to avoid potential bugs) 

# Usage :inbox_tray:
Any user can either clone this repository in its own computer or download specific files in order to replicate PADeCI's job.

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

# Authors :writing_hand:
Fernando Alarid-Escudero   | [GitHub](https://github.com/feralaes) | [Twitter](https://twitter.com/feralaes) |

Andrea Luviano             | [GitHub](https://github.com/AndreaLuviano) | [Twitter](https://twitter.com/AndreaLuviano)

Regina Isabel Medina       | [GitHub](https://github.com/RMedina19) | [Twitter](https://twitter.com/regi_medina) |

Hirvin Díaz                | [GitHub](https://github.com/HirvinDiaz) | [Twitter](https://twitter.com/HazaelDiaz93) |

________

# Nota metodológica | Methology note :world_map:
## Lista de municipios de la Zona Metropolinata del Valle de México (ZMVM) | Mexico City Metropolitan Area (MCMA)
List of Mexico City Metopolitan Area's counties:
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
