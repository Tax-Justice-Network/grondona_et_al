********************************************************************************
* Grondona et al. (2024): Which money to follow
********************************************************************************
* Do-File 1: Generate dataset to assess a country's vulnerability towards illicit
*            financial flows
********************************************************************************
* Author: Alison Schultz
* Created: 6 December 2023
* Last updated: 16 October 2024

** Description:
* - This DoFile is the first of three relevant files to replicate the work pre-
*   sented in the paper "Grondona, Verónica, Markus Meinzer, Nara Monkam,
*   Alison Schultz, and Gonzalo Villanueva (2024): Which Money to Follow?
*   Evaluating Country-Specific Vulnerabilities to Illicit Financial Flows"
* - This DoFile imports data on bilateral transactions and secrecy scores
* - It then combines these data to obtain a country-level vulnerability assessment 
*   towards illicit financial flows (IFF vulnerability) as outlined in the paper
* - The second Do-File ("2_country_specific_vulnerabilities.do") estimates the
*   country-specific IFF vulnerabilities reported in the paper, the Python code
*   "3_figures.ipynb" replicates all figures reported in the paper.

** Outline of this Do-File:
* 1. Merge data on countries' financial secrecy with bilateral macroeconomic flow data
* 2. Calculate country-level vulnerability, exposure, and contribution to different
*    macroeconomic channels

********************************************************************************
* O. Specify revelant paths
********************************************************************************
glo dir "`c(pwd)'/.."
glo data "${dir}/data"
glo output "${dir}/output"
glo src "${dir}/src"


********************************************************************************
* 1. Merge data on countries' financial secrecy with bilateral macroeconomic flow
*    data
********************************************************************************

* 1.1 Data on secrecy scores
********************************************************************************
* Data on a country's secrecy scores is taken from the Tax Justice Network's 
* Financial Secrecy Index that can be accessed here: https://fsi.taxjustice.net/

* The cleaned data is stored in: "${data}/raw/fsi_scores.dta"


********************************************************************************
* 1.2 Bilateral macroeconomic flow data
********************************************************************************
* 1.2.1 Portfolio Investment
********************************************************************************
* Bilateral portfolio investment is taken from the IMF's Coordinated Portfolio
* Investment Survey (CPIS, https://data.imf.org/?sk=b981b4e3-4e58-467e-9b90-9de0c3367363)
* It is cleaned to include mirrored statistics where missings occur. E.g., if we 
* have outward portfolio investment reported from country A to country B but
* inward portfolio investment from country A are not reported by country B,
* we fill these missing imports by the known export values between A and B.

* The cleaned data is stored in: "${data}/raw/portfolio_investment.dta"


* 1.2.2 FDI
********************************************************************************
* Bilateral FDI data is from the IMF's Coordinated Direct Investment Survey
* (CDIS, https://data.imf.org/?sk=40313609-F037-48C1-84B1-E1F1CE54D6D5)
* The data is cleaned to include mirrored statistics where missings occur 
* E.g., if we have outward FDI reported from country A to country B but
* inward FDI from country A are not reported by country B,
* we fill these missing imports by the known export values between A and B.

* The cleaned data is stored in: "${data}/raw/fdi.dta"

* 1.2.3 Trade data
********************************************************************************
* The trade data is from Comtrade but processed and cleaned by CEPPII BACI. 
* The full data can be accessed here:
* https://www.cepii.fr/CEPII/en/bdd_modele/bdd_modele_item.asp?id=37
* We include mirrored statistics where missings occur in one but not in the other
* direction. E.g., if we have exports reported from country A to country B but
* imports from country A are not reported by country B, we fill these missing imports
* by the known export values between A and B.

* The cleaned data is stored in: "${data}/raw/trade.dta"


********************************************************************************
* 1.3. Other relevant data
********************************************************************************

* 1.3.1 GDP
********************************************************************************
* GDP is taken from the World Bank data and can be found here: 
* https://data.worldbank.org/indicator/NY.GDP.MKTP.CD

* The data is stored in: "${data}/raw/gdp.dta"

* 1.3.2 Region and country names
********************************************************************************
* Data on the countries' names and regions is taken from the Tax Justice Network.

* The data is stored in: "${data}/raw/region.dta"

********************************************************************************
* 1.4 Merge datasets
********************************************************************************

* 1.4.1 Merge macroeconomic data
********************************************************************************
* Merge bilateral data
use "${data}/raw/portfolio_investment.dta", clear
merge 1:1 r_iso3 p_iso3 year using "${data}/raw/fdi.dta", nogen
merge 1:1 r_iso3 p_iso3 year using "${data}/raw/trade.dta", nogen
* Merge GDP and region to reporting countries
merge m:1 r_iso3 year using "${data}/raw/gdp.dta", nogen
rename r_iso3 iso3
merge m:1 iso3 using "${data}/raw/region.dta", keep(master match) nogen
rename country_name r_country_name
rename region_tjn r_region_tjn
rename iso3 r_iso3
* Correct country names and regions
replace r_country_name = "Antarctica" if r_iso3 == "ATA"
replace r_country_name = "Cocos Islands" if r_iso3 == "CCK"
replace r_region_tjn = "Oceania" if r_iso3 == "CCK"
replace r_country_name = "Western Sahara" if r_iso3 == "ESH"
replace r_region_tjn = "Africa" if r_iso3 == "ESH"
replace r_country_name = "French Southern Territories" if r_iso3 == "ATF"
replace r_region_tjn = "Africa" if r_iso3 == "ATF" 
replace r_country_name = "Saint Barthélemy" if r_iso3 == "BLM"
replace r_region_tjn = "Caribbean/American isl." if r_iso3 == "BLM"
replace r_country_name = "Bouvet Island" if r_iso3 == "BVT"
replace r_region_tjn = "Caribbean/American isl." if r_iso3 == "BVT" 
replace r_country_name = "Christmas Island" if r_iso3 == "CXR"
replace r_region_tjn = "Oceania" if r_iso3 == "CXR"
replace r_country_name = "Heard Island and McDonald Islands" if r_iso3 == "HMD"
replace r_region_tjn = "Oceania" if r_iso3 == "HMD"
replace r_country_name = "Martinique" if r_iso3 == "MTQ"
replace r_region_tjn = "Caribbean/American isl." if r_iso3 == "MTQ"
replace r_country_name = "Mayotte" if r_iso3 == "MYT"
replace r_region_tjn = "Africa" if r_iso3 == "MYT"
replace r_country_name = "Norfolk" if r_iso3 == "NFK"
replace r_region_tjn = "Oceania" if r_iso3 == "NFK"
replace r_country_name = "Niue" if r_iso3 == "NIU"
replace r_region_tjn = "Oceania" if r_iso3 == "NIU"
replace r_country_name = "Pitcairn Islands" if r_iso3 == "PCN"
replace r_region_tjn = "Oceania" if r_iso3 == "PCN"
replace r_country_name = "Réunion" if r_iso3 == "REU"
replace r_region_tjn = "Africa" if r_iso3 == "REU"
replace r_country_name = "South Georgia and the South Sandwich Islands" if r_iso3 == "SGS"
replace r_region_tjn = "Caribbean/American isl." if r_iso3 == "SGS" // Geographical proximity
replace r_country_name = "Saint Helena, Ascension and Tristan da Cunha" if r_iso3 == "SHN"
replace r_region_tjn = "Africa" if r_iso3 == "SHN"
replace r_country_name = "Saint Pierre and Miquelon" if r_iso3 == "SPM"
replace r_region_tjn = "Northern America" if r_iso3 == "SPM"
replace r_country_name = "Tokelau" if r_iso3 == "TKL"
replace r_region_tjn = "Oceania" if r_iso3 == "TKL"
replace r_country_name = "United States Minor Outlying Islands" if r_iso3 == "UMI"
replace r_region_tjn = "Oceania" if r_iso3 == "UMI"
replace r_country_name = "Vatican City" if r_iso3 == "VAT"
replace r_region_tjn = "Europe" if r_iso3 == "VAT"
replace r_country_name = "Palestine" if r_iso3 == "PAL"
replace r_region_tjn = "Asia" if r_iso3 == "PAL"
replace r_country_name = "East Timor" if r_iso3 == "TMP"
replace r_region_tjn = "Asia" if r_iso3 == "TMP"
replace r_country_name = "Western Sahara" if r_iso3 == "WSH"
replace r_region_tjn = "Africa" if r_iso3 == "WSH"
replace r_country_name = "Kosovo" if r_iso3 == "XXK"
replace r_region_tjn = "Europe" if r_iso3 == "XXK"

* Merge region to partner countries
rename p_iso3 iso3
merge m:1 iso3 using "${data}/raw/region.dta", keep(master match) nogen
rename country_name p_country_name
rename region_tjn p_region_tjn
rename iso3 p_iso3
* Correct country names and regions
replace p_country_name = "Antarctica" if p_iso3 == "ATA"
replace p_country_name = "Cocos Islands" if p_iso3 == "CCK"
replace p_region_tjn = "Oceania" if p_iso3 == "CCK"
replace p_country_name = "Western Sahara" if p_iso3 == "ESH"
replace p_region_tjn = "Africa" if p_iso3 == "ESH"
replace p_country_name = "French Southern Territories" if p_iso3 == "ATF"
replace p_region_tjn = "Africa" if p_iso3 == "ATF" // Geographical proximity
replace p_country_name = "Saint Barthélemy" if p_iso3 == "BLM"
replace p_region_tjn = "Caribbean/American isl." if p_iso3 == "BLM"
replace p_country_name = "Bouvet Island" if p_iso3 == "BVT"
replace p_region_tjn = "Caribbean/American isl." if p_iso3 == "BVT" // Geographical proximity
replace p_country_name = "Christmas Island" if p_iso3 == "CXR"
replace p_region_tjn = "Oceania" if p_iso3 == "CXR"
replace p_country_name = "Heard Island and McDonald Islands" if p_iso3 == "HMD"
replace p_region_tjn = "Oceania" if p_iso3 == "HMD"
replace p_country_name = "Martinique" if p_iso3 == "MTQ"
replace p_region_tjn = "Caribbean/American isl." if p_iso3 == "MTQ"
replace p_country_name = "Mayotte" if p_iso3 == "MYT"
replace p_region_tjn = "Africa" if p_iso3 == "MYT"
replace p_country_name = "Norfolk" if p_iso3 == "NFK"
replace p_region_tjn = "Oceania" if p_iso3 == "NFK"
replace p_country_name = "Niue" if p_iso3 == "NIU"
replace p_region_tjn = "Oceania" if p_iso3 == "NIU"
replace p_country_name = "Pitcairn Islands" if p_iso3 == "PCN"
replace p_region_tjn = "Oceania" if p_iso3 == "PCN"
replace p_country_name = "Réunion" if p_iso3 == "REU"
replace p_region_tjn = "Africa" if p_iso3 == "REU"
replace p_country_name = "South Georgia and the South Sandwich Islands" if p_iso3 == "SGS"
replace p_region_tjn = "Caribbean/American isl." if p_iso3 == "SGS" // Geographical proximity
replace p_country_name = "Saint Helena, Ascension and Tristan da Cunha" if p_iso3 == "SHN"
replace p_region_tjn = "Africa" if p_iso3 == "SHN"
replace p_country_name = "Saint Pierre and Miquelon" if p_iso3 == "SPM"
replace p_region_tjn = "Northern America" if p_iso3 == "SPM"
replace p_country_name = "Tokelau" if p_iso3 == "TKL"
replace p_region_tjn = "Oceania" if p_iso3 == "TKL"
replace p_country_name = "United States Minor Outlying Islands" if p_iso3 == "UMI"
replace p_region_tjn = "Oceania" if p_iso3 == "UMI"
replace p_country_name = "Vatican City" if p_iso3 == "VAT"
replace p_region_tjn = "Europe" if p_iso3 == "VAT"
replace p_country_name = "Palestine" if p_iso3 == "PAL"
replace p_region_tjn = "Asia" if p_iso3 == "PAL"
replace p_country_name = "East Timor" if p_iso3 == "TMP"
replace p_region_tjn = "Asia" if p_iso3 == "TMP"
replace p_country_name = "Western Sahara" if p_iso3 == "WSH"
replace p_region_tjn = "Africa" if p_iso3 == "WSH"
replace p_country_name = "Kosovo" if p_iso3 == "XXK"
replace p_region_tjn = "Europe" if p_iso3 == "XXK"


* 1.4.2 Merge secrecy scores
********************************************************************************
rename r_iso3 iso3
merge m:1 iso3 using "${data}/raw/fsi_scores.dta", nogen
rename iso3 r_iso3
rename fsi_2022_ss fsi_2022_ss_r
rename p_iso3 iso3
merge m:1 iso3 using "${data}/raw/fsi_scores.dta", nogen
rename iso3 p_iso3
rename fsi_2022_ss fsi_2022_ss_p

drop if r_iso3 == "" | r_iso3 == "0" | p_iso3 == "" | p_iso3 == "0" | year == . | year == 0
save "${data}/intermediate/iff_risk_raw.dta", replace


********************************************************************************
* 2. Calculate country-level vulnerability, exposure and contribution to different
*    channels
********************************************************************************
* For a definition of the different measures, please see the paper's method section.

* 2.1 Create bilateral dataset with vulnerability, exposure, and contribution
********************************************************************************
use "${data}/intermediate/iff_risk_raw.dta", clear

drop if fsi_2022_ss_p == .
drop if r_iso3 == "ANT" | r_iso3 == "WLD" | r_iso3 == "EU2" | r_iso3 == "YUG" | r_iso == "XXK"
drop if p_iso3 == "ANT" | p_iso3 == "WLD" | p_iso3 == "EU2" | p_iso3 == "YUG" | p_iso == "XXK"

foreach var of varlist pi_inward - imports_tot {
	gen `var'_x_ss = `var' * fsi_2022_ss_p
	bysort r_iso3 year: egen weigh_ss_`var' = total(`var'_x_ss)
	replace weigh_ss_`var' = . if weigh_ss_`var' == 0
	bysort r_iso3 year: egen tot_`var' = total(`var')
	replace tot_`var' = . if tot_`var' == 0
	
	* Vulnerability
	bysort r_iso3 year: gen vuln_ss_`var' = weigh_ss_`var'/tot_`var'
	
	*Exposure
	bysort r_iso3 year: gen expos_ss_`var' = weigh_ss_`var'/gdp
	
	* Intensity
	bysort r_iso3 year: gen intens_`var' = tot_`var'/gdp
	
	* Contribution (weighted with a cubic root weight)
	gen cubicr_`var' = `var'^(1/3)
	bysort year: egen tot_cubicr_`var' = total(cubicr_`var')
	gen cubic_weight_`var'= cubicr_`var' / tot_cubicr_`var'
	gen contr_ss_`var' = cubic_weight_`var' * fsi_2022_ss_p^3
	bysort year: egen tot_contr_ss_`var' = total(contr_ss_`var')
	gen contr_ss_share_`var' = contr_ss_`var'/tot_contr_ss_`var'
	drop cubicr_* cubic_weight_* tot_cubicr_* tot_contr* *_x_* weigh_*
}

order r_iso3 r_country_name gdp p_iso3 p_country_name year r_region_tjn p_region_tjn ///
     vuln_ss_fdi_inward vuln_ss_fdi_eq_inward vuln_ss_fdi_debt_inward ///
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
	 vuln_ss_exports_stone vuln_ss_exports_textil vuln_ss_exports_vehicle ///
	 expos_ss_fdi_inward expos_ss_fdi_eq_inward expos_ss_fdi_debt_inward ///
     expos_ss_fdi_outward expos_ss_fdi_eq_outward expos_ss_fdi_debt_outward ///
	 expos_ss_pi_inward expos_ss_pi_eq_inward expos_ss_pi_debt_inward ///
	 expos_ss_pi_outward expos_ss_pi_eq_outward expos_ss_pi_debt_outward  ///
	 expos_ss_imports_tot ///
	 expos_ss_imports_agric expos_ss_imports_chemic expos_ss_imports_electro ///
	 expos_ss_imports_machine expos_ss_imports_metals expos_ss_imports_mineral  ///
	 expos_ss_imports_stone expos_ss_imports_textil expos_ss_imports_vehicle ///
	 expos_ss_exports_tot ///
	 expos_ss_exports_agric expos_ss_exports_chemic tot* expos_ss_exports_electro ///
	 expos_ss_exports_machine expos_ss_exports_metals expos_ss_exports_mineral  ///
	 expos_ss_exports_stone expos_ss_exports_textil expos_ss_exports_vehicle ///
	 intens_fdi_inward intens_fdi_eq_inward intens_fdi_debt_inward ///
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
	 intens_exports_stone intens_exports_textil intens_exports_vehicle ///
	 tot*

save "${data}/final/iff_risk_bilateral.dta", replace
export delimited "${data}/final/iff_risk_bilateral.csv", replace 

* 2.2 Create dataset with vulnerability, exposure, and contribution per reporting 
*     country
********************************************************************************
use "${data}/final/iff_risk_bilateral.dta", clear
keep r_iso3 r_country_name r_region_tjn year gdp vuln* expos* intens* tot*
rename r_iso3 iso3
rename r_country_name country_name 
rename r_region_tjn region_tjn
duplicates drop


order iso3 country_name year region_tjn gdp ///
     vuln_ss_fdi_inward vuln_ss_fdi_eq_inward vuln_ss_fdi_debt_inward ///
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
	 vuln_ss_exports_stone vuln_ss_exports_textil vuln_ss_exports_vehicle ///
	 expos_ss_fdi_inward expos_ss_fdi_eq_inward expos_ss_fdi_debt_inward ///
     expos_ss_fdi_outward expos_ss_fdi_eq_outward expos_ss_fdi_debt_outward ///
	 expos_ss_pi_inward expos_ss_pi_eq_inward expos_ss_pi_debt_inward ///
	 expos_ss_pi_outward expos_ss_pi_eq_outward expos_ss_pi_debt_outward  ///
	 expos_ss_imports_tot ///
	 expos_ss_imports_agric expos_ss_imports_chemic expos_ss_imports_electro ///
	 expos_ss_imports_machine expos_ss_imports_metals expos_ss_imports_mineral  ///
	 expos_ss_imports_stone expos_ss_imports_textil expos_ss_imports_vehicle ///
	 expos_ss_exports_tot ///
	 expos_ss_exports_agric expos_ss_exports_chemic tot* expos_ss_exports_electro ///
	 expos_ss_exports_machine expos_ss_exports_metals expos_ss_exports_mineral  ///
	 expos_ss_exports_stone expos_ss_exports_textil expos_ss_exports_vehicle ///
	 intens_fdi_inward intens_fdi_eq_inward intens_fdi_debt_inward ///
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
	 intens_exports_stone intens_exports_textil intens_exports_vehicle ///
	 tot*
	
save "${data}/final/iff_risk_reportingcountry.dta", replace
export delimited "${data}/final/iff_risk_reportingcountry.csv", replace 


* 2.2 Create dataset with vulnerability, exposure, and contribution in long format
*     including regional and global averages
********************************************************************************

use "${data}/final/iff_risk_reportingcountry.dta", clear
reshape long vuln_ss_ expos_ss_ intens_ tot_, i(iso3 country_name year) j(channel) string
rename vuln_ss_ vulnerability
rename expos_ss_ exposure
rename intens_ intensity
rename tot_ value_busd
replace value_busd = value_busd/1e9


replace channel = "Inward FDI" if channel == "fdi_inward"
replace channel = "Outward FDI" if channel == "fdi_outward"
replace channel = "Inward FDI: Debt" if channel == "fdi_debt_inward"
replace channel = "Outward FDI: Debt" if channel == "fdi_debt_outward"
replace channel = "Inward FDI: Equity" if channel == "fdi_eq_inward"
replace channel = "Outward FDI: Equity" if channel == "fdi_eq_outward"

replace channel = "Inward Portfolio Investment" if channel == "pi_inward"
replace channel = "Outward Portfolio Investment" if channel == "pi_outward"
replace channel = "Inward Portfolio Inv.: Debt" if channel == "pi_debt_inward"
replace channel = "Outward Portfolio Inv.: Debt" if channel == "pi_debt_outward"
replace channel = "Inward Portfolio Inv.: Equity" if channel == "pi_eq_inward"
replace channel = "Outward Portfolio Inv.: Equity" if channel == "pi_eq_outward"

replace channel = "Outward Trade (Exports)" if channel == "exports_tot"
replace channel = "Exports: Agriculture" if channel == "exports_agric"
replace channel = "Exports: Chemicals" if channel == "exports_chemic"
replace channel = "Exports: Electronics" if channel == "exports_electro"
replace channel = "Exports: Machinery" if channel == "exports_machine"
replace channel = "Exports: Metals" if channel == "exports_metals"
replace channel = "Exports: Minerals" if channel == "exports_mineral"
replace channel = "Exports: Stone" if channel == "exports_stone"
replace channel = "Exports: Textiles" if channel == "exports_textil"
replace channel = "Exports: Vehicles" if channel == "exports_vehicle"

replace channel = "Inward Trade (Imports)" if channel == "imports_tot"
replace channel = "Imports: Agriculture" if channel == "imports_agric"
replace channel = "Imports: Chemicals" if channel == "imports_chemic"
replace channel = "Imports: Electronics" if channel == "imports_electro"
replace channel = "Imports: Machinery" if channel == "imports_machine"
replace channel = "Imports: Metals" if channel == "imports_metals"
replace channel = "Imports: Minerals" if channel == "imports_mineral"
replace channel = "Imports: Stone" if channel == "imports_stone"
replace channel = "Imports: Textiles" if channel == "imports_textil"
replace channel = "Imports: Vehicles" if channel == "imports_vehicle"


* Generate regional and global averages
foreach var of varlist vulnerability exposure intensity {
	bysort channel year: egen `var'_glo = median(`var')
	bysort region channel year: egen `var'_reg = median(`var')	
}

bysort channel year: egen value_busd_glo = total(value_busd)
bysort region channel year: egen value_busd_reg = total(value_busd)

save "${data}/final/iff_risk_reportingcountry_long", replace
export delimited "${data}/final/iff_risk_reportingcountry_long.csv", replace 