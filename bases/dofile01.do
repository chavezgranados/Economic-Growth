******************** Hechos estilizados ******************
**********************************************************

* GDP per capita (2017=100)

twoway (line rgdpo year if country == "Peru", lcolor(blue)) ///
       (line rgdpo year if country == "Mexico", lcolor(red)) ///
       (line rgdpo year if country == "Brazil", lcolor(green)) ///
       (line rgdpo year if country == "Germany", lcolor(black)) ///
       (line rgdpo year if country == "Japan", lcolor(orange)), ///
       legend(label(1 "Perú") label(2 "México") label(3 "Brasil") label(4 "Alemania") 		label(5 "Japón")) ///
       title("PBI per cápita en PPA, 2017=100 (en millones US$)") ///
       ytitle("PBI per cápita") xtitle("Año") ///
       xlabel(1950(10)2020, nogrid) ylabel(, nogrid) ///
       xscale(range(1950 2020))

