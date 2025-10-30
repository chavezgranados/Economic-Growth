*-------------------------------------------------------------
*----------------------   CONVERGENCIA   ---------------------
*-------------------------------------------------------------
* Luis Chávez, 2025 ©

global bases "C:\Users\LENOVO\Downloads"
use "$bases/pwt110.dta", clear

merge m:1 countrycode using "$bases/countriesWB.dta"
drop Economy _merge
rename Region region
generate gdppc = rgdpna/pop
generate ln_gdppc = ln(gdppc)


*1. Hechos estilizados =====================================


{
preserve
generate decade = floor(year/10)*10
collapse (mean) ln_gdppc, by(region decade)
drop if decade==.
reshape wide ln_gdppc, i(region) j(decade)

rename ln_gdppc1960 decade60
rename ln_gdppc1980 decade80
rename ln_gdppc2000 decade00
rename ln_gdppc2020 decade20

graph dot decade60 decade80 decade00 decade20, over(region) ///
    legend(label(1 "1960s") label(2 "1980s") label(3 "2000s") label(4 "2020s") ///
           pos(6) rows(1) size(small) ring(0)) ///
    graphregion(fcolor(gs16)) ///
    marker(1, mcolor("160 160 160")) ///
    marker(2, mcolor("100 140 220")) ///
    marker(3, mcolor("100 180 100")) ///
    marker(4, mcolor("240 150 70")) ///
    ylab(9(0.5)13.5) ///
    ytitle("ln PIB per cápita") ///
    exclude0 ///
    name(Fig1, replace)

restore
}


keep if inlist(year,1960,2019)
bys countrycode (year): gen growth = (gdppc - gdppc[_n-1]) / gdppc[_n-1] if year==2019
bys countrycode (year): gen gdppc1960 = gdppc[1] if year==2019
encode Incomegroup, gen(inc)

generate inc3 = .
replace inc3 = 1 if Incomegroup == "Low income"
replace inc3 = 2 if inlist(Incomegroup, "Lower middle income", "Upper middle income")
replace inc3 = 3 if Incomegroup == "High income"

label define inc3lbl 1 "Low" 2 "Middle" 3 "High"
label values inc3 inc3lbl

* En niveles -------
twoway (scatter growth gdppc1960 if inc3==1, mcolor("`col1'") mlabel(countrycode) mlabsize(vsmall)) (lfit growth gdppc1960 if inc3==1 , lcolor("orange") mlabel(countrycode) mlabsize(vsmall)) (scatter growth gdppc1960 if inc3==2, mcolor("`col2'") mlabel(countrycode) mlabsize(vsmall) fi(10)) (lfit growth gdppc1960 if inc3==2, lcolor("lime") mlabel(countrycode) mlabsize(vsmall)) (scatter growth gdppc1960 if inc3==3, mcolor("`col3'") mlabel(countrycode) mlabsize(vsmall)) (lfit growth gdppc1960 if inc3==3, lcolor("magenta") fi(10)), xtitle("PIB per cápita 1960") ytitle("Tasa PIB per cápita 1960-2019") legend(order(1 "Low income" 3 "Middle income" 5 "High income") region(lwidth(none)) ring(0) pos(1) size(small) rows(1)) graphregion(fcolor(gs16)) name(Fig2, replace) xlabel(, nogrid) ylabel(, nogrid)


* En  logaritmos ------
gen ln_gdppc1960=ln(gdppc1960)

twoway (scatter growth ln_gdppc1960 if inc3==1, mcolor("`col1'") mlabel(countrycode) mlabsize(vsmall)) (lfit growth ln_gdppc1960 if inc3==1 , lcolor("orange") mlabel(countrycode) mlabsize(vsmall)) (scatter growth ln_gdppc1960 if inc3==2, mcolor("`col2'") mlabel(countrycode) mlabsize(vsmall) fi(10)) (lfit growth ln_gdppc1960 if inc3==2, lcolor("lime") mlabel(countrycode) mlabsize(vsmall)) (scatter growth ln_gdppc1960 if inc3==3, mcolor("`col3'") mlabel(countrycode) mlabsize(vsmall)) (lfit growth ln_gdppc1960 if inc3==3, lcolor("magenta") fi(10)), xtitle("PIB per cápita 1960") ytitle("Tasa PIB per cápita 1960-2019") legend(order(1 "Low income" 3 "Middle income" 5 "High income") region(lwidth(none)) ring(0) pos(1) size(small) rows(1)) graphregion(fcolor(gs16)) name(Fig3, replace) xlabel(, nogrid) ylabel(, nogrid)



*2. Convergencia beta =====================================
use "$bases/pwt110.dta", clear
encode countrycode, gen(countrycode2)
xtset countrycode2 year
gen lngdp = ln(cgdpe)
gen growth = lngdp - L.lngdp
gen lny0 = L.lngdp
reg growth lny0
// No hay evidencia de convergencia absoluta.
