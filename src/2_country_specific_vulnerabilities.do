********************************************************************************
* Grondona et al. (2024): Which money to follow
********************************************************************************
* Do-File 2: Calculate country specific vulnerabilities/risks in different 
*            channels
********************************************************************************
* Author: Alison Schultz
* Created: 6 December 2023
* Last updated: 16 October 2024

** Description:
* - This DoFile is the second of three relevant files to replicate the work pre-
*   sented in the paper "Grondona, Verónica, Markus Meinzer, Nara Monkam,
*   Alison Schultz, and Gonzalo Villanueva (2024): Which Money to Follow?
*   Evaluating Country-Specific Vulnerabilities to Illicit Financial Flows"
* - This Do-File estimates the country-specific IFF vulnerabilities reported in 
*   the paper 
* - The DoFile builds on the datasets generated in the Do-File "1_create_dataset.do"
*   which include measures on countries' vulnerability, exposure, and contribution
*   to risk of illicit financial flows (IFFs)
* - The Python code "3_figures.ipynb" replicates all figures reported in the paper.

** Outline of this Do-File:
* 1. Generate results on vulnerability and exposure for all countries
*    1.1 Vulnerability 2020
*    1.2 Exposure 202
* 2. Generate country-specific results on vulnerability, exposure, and partner
*    countries' contribution to IFF risks
*    1.1 

********************************************************************************
* O. Specify revelant paths
********************************************************************************
glo dir "`c(pwd)'/.."
glo data "${dir}/data"
glo output "${dir}/output"
glo src "${dir}/src"

********************************************************************************
* 1. Generate results on vulnerability and exposure for all countries
********************************************************************************

* 1.1 Vulnerability 2020
********************************************************************************
use "${data}/final/iff_risk_reportingcountry.dta", clear
keep if year == 2020
replace country_name = "Laos" if iso3 == "LAO"
replace country_name = "Aland" if iso3 == "ALA"
replace country_name = "Antarctica" if iso3 == "ATA"
replace country_name = "Cocos Islands" if iso3 == "CCK"
replace country_name = "Western Sahara" if iso3 == "ESH"
replace country_name = "French Southern Territories" if iso3 == "ATF"
replace country_name = "Saint Barthélemy" if iso3 == "BLM"
replace country_name = "Bouvet Island" if iso3 == "BVT"
replace country_name = "Christmas Island" if iso3 == "CXR"
replace country_name = "Heard Island and McDonald Islands" if iso3 == "HMD"
replace country_name = "Martinique" if iso3 == "MTQ"
replace country_name = "Mayotte" if iso3 == "MYT"
replace country_name = "Norfolk" if iso3 == "NFK"
replace country_name = "Niue" if iso3 == "NIU"
replace country_name = "Pitcairn Islands" if iso3 == "PCN"
replace country_name = "Réunion" if iso3 == "REU"
replace country_name = "South Georgia and the South Sandwich Islands" if iso3 == "SGS"
replace country_name = "Saint Helena, Ascension and Tristan da Cunha" if iso3 == "SHN"
replace country_name = "Saint Pierre and Miquelon" if iso3 == "SPM"
replace country_name = "Tokelau" if iso3 == "TKL"
replace country_name = "United States Minor Outlying Islands" if iso3 == "UMI"
replace country_name = "Vatican City" if iso3 == "VAT"
replace country_name = "Palestine" if iso3 == "PAL"
replace country_name = "East Timor" if iso3 == "TMP"
replace country_name = "Western Sahara" if iso3 == "WSH"
replace country_name = "Kosovo" if iso3 == "XXK"

preserve
keep iso3 country_name region_tjn vuln_ss_fdi_inward vuln_ss_fdi_eq_inward vuln_ss_fdi_debt_inward ///
     vuln_ss_fdi_outward vuln_ss_fdi_eq_outward vuln_ss_fdi_debt_outward ///
	 vuln_ss_pi_inward vuln_ss_pi_eq_inward vuln_ss_pi_debt_inward ///
	 vuln_ss_pi_outward vuln_ss_pi_eq_outward vuln_ss_pi_debt_outward  ///
	 vuln_ss_imports_tot ///
	 vuln_ss_imports_agric vuln_ss_imports_chemic vuln_ss_imports_electro ///
	 vuln_ss_imports_machine vuln_ss_imports_metals vuln_ss_imports_mineral  ///
	 vuln_ss_imports_stone vuln_ss_imports_textil vuln_ss_imports_vehicle ///
	 vuln_ss_exports_tot ///
	 vuln_ss_exports_agric vuln_ss_exports_chemic vuln_ss_exports_electro ///
	 vuln_ss_exports_machine vuln_ss_exports_metals vuln_ss_exports_mineral  ///
	 vuln_ss_exports_stone vuln_ss_exports_textil vuln_ss_exports_vehicle 
order iso3 country_name region_tjn vuln_ss_fdi_inward vuln_ss_fdi_eq_inward vuln_ss_fdi_debt_inward ///
     vuln_ss_fdi_outward vuln_ss_fdi_eq_outward vuln_ss_fdi_debt_outward ///
	 vuln_ss_pi_inward vuln_ss_pi_eq_inward vuln_ss_pi_debt_inward ///
	 vuln_ss_pi_outward vuln_ss_pi_eq_outward vuln_ss_pi_debt_outward  ///
	 vuln_ss_imports_tot ///
	 vuln_ss_imports_agric vuln_ss_imports_chemic vuln_ss_imports_electro ///
	 vuln_ss_imports_machine vuln_ss_imports_metals vuln_ss_imports_mineral  ///
	 vuln_ss_imports_stone vuln_ss_imports_textil vuln_ss_imports_vehicle ///
	 vuln_ss_exports_tot ///
	 vuln_ss_exports_agric vuln_ss_exports_chemic vuln_ss_exports_electro ///
	 vuln_ss_exports_machine vuln_ss_exports_metals vuln_ss_exports_mineral  ///
	 vuln_ss_exports_stone vuln_ss_exports_textil vuln_ss_exports_vehicle 
	
* generate regional and global averages
foreach var of varlist vuln_ss_fdi_inward - vuln_ss_exports_vehicle {
	egen `var'_glo = mean(`var')
	bysort region: egen `var'_reg = mean(`var')	
}	

export excel using "${output}/tables/Overview_data.xlsx", ///
     sheet(vulnerability_all, modify) cell(A6) keepcellfmt
	 
export excel using "${output}/tables/Figures_excel.xlsx", ///
     sheet(vulnerability_all, modify) cell(A6) keepcellfmt
	 

* 1.2 Exposure 2020
********************************************************************************
restore
preserve
keep iso3 country_name region_tjn expos_ss_fdi_inward expos_ss_fdi_eq_inward expos_ss_fdi_debt_inward ///
     expos_ss_fdi_outward expos_ss_fdi_eq_outward expos_ss_fdi_debt_outward ///
	 expos_ss_pi_inward expos_ss_pi_eq_inward expos_ss_pi_debt_inward ///
	 expos_ss_pi_outward expos_ss_pi_eq_outward expos_ss_pi_debt_outward  ///
	 expos_ss_imports_tot ///
	 expos_ss_imports_agric expos_ss_imports_chemic expos_ss_imports_electro ///
	 expos_ss_imports_machine expos_ss_imports_metals expos_ss_imports_mineral  ///
	 expos_ss_imports_stone expos_ss_imports_textil expos_ss_imports_vehicle ///
	 expos_ss_exports_tot ///
	 expos_ss_exports_agric expos_ss_exports_chemic expos_ss_exports_electro ///
	 expos_ss_exports_machine expos_ss_exports_metals expos_ss_exports_mineral  ///
	 expos_ss_exports_stone expos_ss_exports_textil expos_ss_exports_vehicle 
order iso3 country_name region_tjn expos_ss_fdi_inward expos_ss_fdi_eq_inward expos_ss_fdi_debt_inward ///
     expos_ss_fdi_outward expos_ss_fdi_eq_outward expos_ss_fdi_debt_outward ///
	 expos_ss_pi_inward expos_ss_pi_eq_inward expos_ss_pi_debt_inward ///
	 expos_ss_pi_outward expos_ss_pi_eq_outward expos_ss_pi_debt_outward  ///
	 expos_ss_imports_tot ///
	 expos_ss_imports_agric expos_ss_imports_chemic expos_ss_imports_electro ///
	 expos_ss_imports_machine expos_ss_imports_metals expos_ss_imports_mineral  ///
	 expos_ss_imports_stone expos_ss_imports_textil expos_ss_imports_vehicle ///
	 expos_ss_exports_tot ///
	 expos_ss_exports_agric expos_ss_exports_chemic expos_ss_exports_electro ///
	 expos_ss_exports_machine expos_ss_exports_metals expos_ss_exports_mineral  ///
	 expos_ss_exports_stone expos_ss_exports_textil expos_ss_exports_vehicle

export excel using "${output}/tables/Overview_data.xlsx", ///
     sheet(exposure_all, modify) cell(A6) keepcellfmt

export excel using "${output}/tables/Figures_excel.xlsx", ///
     sheet(exposure_all, modify) cell(A6) keepcellfmt
	 
* 1.3 Intensity 2020
********************************************************************************
restore
keep iso3 country_name region_tjn intens_fdi_inward intens_fdi_eq_inward intens_fdi_debt_inward ///
     intens_fdi_outward intens_fdi_eq_outward intens_fdi_debt_outward ///
	 intens_pi_inward intens_pi_eq_inward intens_pi_debt_inward ///
	 intens_pi_outward intens_pi_eq_outward intens_pi_debt_outward  ///
	 intens_imports_tot ///
	 intens_imports_agric intens_imports_chemic intens_imports_electro ///
	 intens_imports_machine intens_imports_metals intens_imports_mineral  ///
	 intens_imports_stone intens_imports_textil intens_imports_vehicle ///
	 intens_exports_tot ///
	 intens_exports_agric intens_exports_chemic intens_exports_electro ///
	 intens_exports_machine intens_exports_metals intens_exports_mineral  ///
	 intens_exports_stone intens_exports_textil intens_exports_vehicle
order iso3 country_name region_tjn intens_fdi_inward intens_fdi_eq_inward intens_fdi_debt_inward ///
     intens_fdi_outward intens_fdi_eq_outward intens_fdi_debt_outward ///
	 intens_pi_inward intens_pi_eq_inward intens_pi_debt_inward ///
	 intens_pi_outward intens_pi_eq_outward intens_pi_debt_outward  ///
	 intens_imports_tot ///
	 intens_imports_agric intens_imports_chemic intens_imports_electro ///
	 intens_imports_machine intens_imports_metals intens_imports_mineral  ///
	 intens_imports_stone intens_imports_textil intens_imports_vehicle ///
	 intens_exports_tot ///
	 intens_exports_agric intens_exports_chemic intens_exports_electro ///
	 intens_exports_machine intens_exports_metals intens_exports_mineral  ///
	 intens_exports_stone intens_exports_textil intens_exports_vehicle
	 
* generate regional and global averages
foreach var of varlist intens_fdi_inward - intens_exports_vehicle {
	egen `var'_glo = mean(`var')
	bysort region: egen `var'_reg = mean(`var')	
}	

export excel using "${output}/tables/Overview_data.xlsx", ///
     sheet(intensity_all, modify) cell(A6) keepcellfmt

export excel using "${output}/tables/Figures_excel.xlsx", ///
     sheet(intensity_all, modify) cell(A6) keepcellfmt
	 
********************************************************************************
* 2. Generate country-specific results on vulnerability, exposure, and partner
*    countries' contribution to IFF risks
********************************************************************************
use "${data}/final/iff_risk_bilateral.dta", clear
keep if year == 2020

foreach var of varlist fdi* pi* {
	replace `var' = `var'/1e6
}

foreach var of varlist imports_* exports_* {
	replace `var' = `var'/1e6
}

keep r_iso3 p_iso r_country_name p_country_name fsi_2022_ss_p contr_ss_fdi_inward ///
     fdi_inward contr_ss_fdi_eq_inward fdi_eq_inward contr_ss_fdi_debt_inward fdi_debt_inward ///
     contr_ss_fdi_outward fdi_outward contr_ss_fdi_eq_outward fdi_eq_outward contr_ss_fdi_debt_outward fdi_debt_outward ///
	 contr_ss_pi_inward pi_inward contr_ss_pi_eq_inward pi_eq_inward contr_ss_pi_debt_inward pi_debt_inward ///
	 contr_ss_pi_outward pi_outward contr_ss_pi_eq_outward pi_eq_outward contr_ss_pi_debt_outward pi_debt_outward  ///
	 contr_ss_imports_tot imports_tot ///
	 contr_ss_imports_agric imports_agric contr_ss_imports_chemic imports_chemic contr_ss_imports_electro imports_electro ///
	 contr_ss_imports_machine imports_machine contr_ss_imports_metals imports_metals  contr_ss_imports_mineral imports_mineral ///
	 contr_ss_imports_stone imports_stone contr_ss_imports_textil imports_textil contr_ss_imports_vehicle imports_vehicle ///
	 contr_ss_exports_tot exports_tot ///
	 contr_ss_exports_agric exports_agric contr_ss_exports_chemic exports_chemic contr_ss_exports_electro exports_electro ///
	 contr_ss_exports_machine exports_machine contr_ss_exports_metals exports_metals contr_ss_exports_mineral exports_mineral  ///
	 contr_ss_exports_stone exports_stone contr_ss_exports_textil exports_textil  contr_ss_exports_vehicle exports_vehicle 
order r_iso3 p_iso r_country_name p_country_name fsi_2022_ss_p contr_ss_fdi_inward fdi_inward ///
     contr_ss_fdi_eq_inward fdi_eq_inward contr_ss_fdi_debt_inward fdi_debt_inward ///
     contr_ss_fdi_outward fdi_outward contr_ss_fdi_eq_outward fdi_eq_outward contr_ss_fdi_debt_outward fdi_debt_outward ///
	 contr_ss_pi_inward pi_inward contr_ss_pi_eq_inward pi_eq_inward contr_ss_pi_debt_inward pi_debt_inward ///
	 contr_ss_pi_outward pi_outward contr_ss_pi_eq_outward pi_eq_outward contr_ss_pi_debt_outward pi_debt_outward  ///
	 contr_ss_imports_tot imports_tot ///
	 contr_ss_imports_agric imports_agric contr_ss_imports_chemic imports_chemic contr_ss_imports_electro imports_electro ///
	 contr_ss_imports_machine imports_machine contr_ss_imports_metals imports_metals  contr_ss_imports_mineral imports_mineral ///
	 contr_ss_imports_stone imports_stone contr_ss_imports_textil imports_textil contr_ss_imports_vehicle imports_vehicle ///
	 contr_ss_exports_tot exports_tot ///
	 contr_ss_exports_agric exports_agric contr_ss_exports_chemic exports_chemic contr_ss_exports_electro exports_electro ///
	 contr_ss_exports_machine exports_machine contr_ss_exports_metals exports_metals contr_ss_exports_mineral exports_mineral  ///
	 contr_ss_exports_stone exports_stone contr_ss_exports_textil exports_textil  contr_ss_exports_vehicle exports_vehicle

* 2.1 Brazil
********************************************************************************
preserve
keep if r_country_name == "Brazil"
egen nonmissing = rowtotal(contr_ss_fdi_outward - contr_ss_exports_vehicle)
keep if nonmissing > 0 & nonmissing != .
drop r_country_name nonmissing r_iso3
gsort -contr_ss_fdi_inward
export delimited "${output}/tables/brazil.csv", replace 
export excel using "${output}/tables/Overview_data.xlsx", ///
    sheet(Brazil, modify) cell(A7) keepcellfmt
	
export excel using "${output}/tables/Figures_excel.xlsx", ///
    sheet(Brazil, modify) cell(A7) keepcellfmt

* Top PI risk contributors table
restore
preserve
keep if r_country_name == "Brazil"
keep p_country_name contr_ss_pi_inward fsi_2022_ss_p
order p_country_name contr_ss_pi_inward fsi_2022_ss_p
egen total_contr = total(contr_ss_pi_inward)
replace contr_ss_pi_inward = contr_ss_pi_inward/total_contr
drop total*
gsort -contr_ss_pi_inward
keep in 1/10
export excel using "${output}/tables/Figures_excel.xlsx", ///
    sheet(Tables_PI_Brazil, modify) cell(B3) keepcellfmt
	
restore
preserve
keep if r_country_name == "Brazil"
keep p_country_name contr_ss_pi_outward fsi_2022_ss_p
order p_country_name contr_ss_pi_outward fsi_2022_ss_p
egen total_contr = total(contr_ss_pi_outward)
replace contr_ss_pi_outward = contr_ss_pi_outward/total_contr
drop total*
gsort -contr_ss_pi_outward
keep in 1/10
export excel using "${output}/tables/Figures_excel.xlsx", ///
    sheet(Tables_PI_Brazil, modify) cell(G3) keepcellfmt
	

* 2.2 Indonesia
********************************************************************************
restore
preserve
keep if r_country_name == "Indonesia"
egen nonmissing = rowtotal(contr_ss_fdi_outward - contr_ss_exports_vehicle)
keep if nonmissing > 0 & nonmissing != .
drop r_country_name nonmissing r_iso3
gsort -contr_ss_fdi_inward
export delimited "${output}/tables/indonesia.csv", replace 
export excel using "${output}/tables/Overview_data.xlsx", ///
    sheet(Indonesia, modify) cell(A7) keepcellfmt
export excel using "${output}/tables/Figures_excel.xlsx", ///
    sheet(Indonesia, modify) cell(A7) keepcellfmt
	
* Top Trade risk contributors table
restore
preserve
keep if r_country_name == "Indonesia"
keep p_country_name contr_ss_imports_tot fsi_2022_ss_p
order p_country_name contr_ss_imports_tot fsi_2022_ss_p
egen total_contr = total(contr_ss_imports_tot)
replace contr_ss_imports_tot = contr_ss_imports_tot/total_contr
drop total*
gsort -contr_ss_imports_tot
keep in 1/10
export excel using "${output}/tables/Figures_excel.xlsx", ///
    sheet(Tables_Trade_Indonesia, modify) cell(B3) keepcellfmt
	
restore
preserve
keep if r_country_name == "Indonesia"
keep p_country_name contr_ss_exports_tot fsi_2022_ss_p
order p_country_name contr_ss_exports_tot fsi_2022_ss_p
egen total_contr = total(contr_ss_exports_tot)
replace contr_ss_exports_tot = contr_ss_exports_tot/total_contr
drop total*
gsort -contr_ss_exports_tot
keep in 1/10
export excel using "${output}/tables/Figures_excel.xlsx", ///
    sheet(Tables_Trade_Indonesia, modify) cell(G3) keepcellfmt
	
	
* 2.3 Nigeria
********************************************************************************
restore
preserve
keep if r_country_name == "Nigeria"
egen nonmissing = rowtotal(contr_ss_fdi_outward - contr_ss_exports_vehicle)
keep if nonmissing > 0 & nonmissing != .
drop r_country_name nonmissing r_iso3
gsort -contr_ss_fdi_inward
export delimited "${output}/tables/nigeria.csv", replace 
export excel using "${output}/tables/Overview_data.xlsx", ///
    sheet(Nigeria, modify) cell(A7) keepcellfmt
export excel using "${output}/tables/Figures_excel.xlsx", ///
    sheet(Nigeria, modify) cell(A7) keepcellfmt
	
* Top FDI risk contributors table
restore
preserve
keep if r_country_name == "Nigeria"
keep p_country_name contr_ss_fdi_inward fsi_2022_ss_p
order p_country_name contr_ss_fdi_inward fsi_2022_ss_p
egen total_contr = total(contr_ss_fdi_inward)
replace contr_ss_fdi_inward = contr_ss_fdi_inward/total_contr
drop total*
gsort -contr_ss_fdi_inward
keep in 1/10
export excel using "${output}/tables/Figures_excel.xlsx", ///
    sheet(Tables_FDI_Nigeria, modify) cell(B3) keepcellfmt
	
restore
preserve
keep if r_country_name == "Nigeria"
keep p_country_name contr_ss_fdi_outward fsi_2022_ss_p
order p_country_name contr_ss_fdi_outward fsi_2022_ss_p
egen total_contr = total(contr_ss_fdi_outward)
replace contr_ss_fdi_outward = contr_ss_fdi_outward/total_contr
drop total*
gsort -contr_ss_fdi_outward
keep in 1/10
export excel using "${output}/tables/Figures_excel.xlsx", ///
    sheet(Tables_FDI_Nigeria, modify) cell(G3) keepcellfmt