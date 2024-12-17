

**** 1) Base conso
cd "/Users/yannperdereau/Desktop/Thèse/3. Présentations de ma thèse/3 - Draft QE mai 2023/Graphes calibration"
import delimited "Conso_Europe.csv", clear

* Faire des chiffres
split date, p("-")
rename date1 year
rename date2 month
gen date2 = year+"-"+month
rename s1 Conso

* Save
save Conso_value, replace


**** 2) M1 ET CREATION M1/C
import delimited "M1_Europe.csv", clear

* Faire des chiffres
split date, p("-")
rename date1 year
rename date2 month
gen date2 = year+"-"+month
rename s1 M1

* Save
save M1_value, replace

* Merge avec la conso
merge 1:1 date2 using Conso_value 

* Garder uniquement les matchs
drop if  _merge == 1 | _merge == 2
drop _merge

* Créer M/C
gen M1_pourcent_C = 100*M1/(Conso*4)
* Graph
gen nombre = 1995 + 0.25*_n
*twoway (scatter M1_pourcent_C nombre)

* Save
save M1_pourcent_C, replace



**** 3) BASE YIELD ****************
import delimited "Yield_curve.csv", clear

* Faire des chiffres
split date, p("-")
rename date1 year
rename date2 month
gen date2 = year+"-"+month
rename s1 yield

* Enlever à partir ZLB
gen number = _n
drop if number >= 2010

* Une seule variable par mois 
collapse (mean) yield, by(date2)


**** 4) RAPPORT ENTRE M/C ET I ********

* Merge avec la C/M
merge 1:1 date2 using M1_pourcent_C 
drop if  _merge == 1 | _merge == 2

* Graphique avec les deux courbes
label variable M1_pourcent_C "Ratio M1 over annual C (%)"
graph twoway (line yield nombre, yaxis(1) lwidth(thick) graphregion(fcolor(white))) ///
(line M1_pourcent_C nombre, yaxis(2) lwidth(thick)), ylabel(, labsize(medium)) ///
xlabel(, labsize(medium)) xtitle("Time", size(medium)) ytitle("1-year government bond rate (%)", size(medium)) ///
legend(label(1 "1-year government bond rate (%)") label(2 "M1/C"))  
* Enregistrement du graphique 1 dans la mémoire
graph save graph1, replace

* Graphique de régression
label variable M1_pourcent_C "Data (2004-2023)"
graph twoway (scatter M1_pourcent_C yield, lwidth(thick) graphregion(fcolor(white))) ///
(lfit M1_pourcent_C yield, lwidth(thick) graphregion(fcolor(white))), ///
xtitle("1-year government bond rate (%)", size(medium)) ytitle("Ratio M1 over annual C (%)", size(medium))
* Enregistrement du graphique 2 dans la mémoire
graph save graph2, replace

* Combinaison des graphiques avec titre commun
*graph combine graph1.gph graph2.gph, cols(2) title("ECB refinancing rate and ratio M1 over C")
graph combine graph1.gph graph2.gph, rows(2)  ysize(2.5) xsize(2) graphregion(fcolor(white))
graph export yield_et_ratio.pdf, replace

* Regression
reg M1_pourcent_C yield


