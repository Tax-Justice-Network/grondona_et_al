# Grondona, Meinzer, Monkam, Schultz, Villanueva (2024)
This repository entails all data and code needed to replicate the paper "Grondona, Verónica, Markus Meinzer, Nara Monkam, Alison Schultz, and Gonzalo Villanueva (2024): Which Money to Follow?  Evaluating Country-Specific Vulnerabilities to Illicit Financial Flows.

Parts of the data is licensed under a Creative Commons Attribution. This means that the data is made freely available for non-commercial use only. Commercial users are required to purchase a separate license. By using any of the data or code of this repository, you accept our license.

The repository entails code and data to assess countries' vulnerability to illicit financial flows (IFFs) through different macroeconomic channels. This approach is summarized in the paper and explained in greater detail in: Cobham, A., Garcia-Bernardo, J., Harari, M., Lépissier, A., Lima, S., Meinzer, M., Montoya Fernández, L., & Moreno, L. (2021). Vulnerability and exposure to illicit financial flows risk in Latin America. Tax Justice Network, available here: https://www.taxjustice.net/wp-content/uploads/2021/01/Vulnerability-and-exposure-to-illicit-financial-flows-risk-in-Latin-America-Tax-Justice-Network-Jan-2021.pdf.

The assessment combines country-level data on countries' financial secrecy with data on bilateral economic stocks and flows, namely imports and exports, inward and outward foreign portfolio investment, and inward and outward foreign direct investment (FDI). It estimates the following concepts:
- Vulnerability of country i to channel k: Degree to which a country is susceptible to IFFs within each specific channel. The vulnerability of country i in channel k is quantified by the weighted average secrecy score of all partner jurisdictions 𝑗∈𝐽 with whom country i has had economic relationships in channel k. The weights are given by the size of the economic relationship, i.e. the value X_k of the stock or flow in channel k.
  
    ![image](https://github.com/user-attachments/assets/1a19530a-c240-4d09-b973-c74e9375956c)

- Intensity of channel k in country i (not explicitly mentioned in paper): Relevance of channel k for a country i's economy, defined as the transaction volume in a channel divided by the country's GDP. While this concept is not explicitly mentioned in the paper, it is the basis for the following concept of "exposure" and part of the code in this repository.
  
    ![image](https://github.com/user-attachments/assets/97a77520-4d23-4b5e-bf90-b8a4dd32e0af)

- Exposure of country i towards channel k: Weighted vulnerability of a given channel against its economic importance. The relevance of channel k to the economy of country i is gauged by the proportion of the stock or flow from channel k in relation to the GDP of country i (i.e. its intensity).
  
    ![image](https://github.com/user-attachments/assets/77a9b48e-f3df-4283-83d0-d0ca15b38ac4)

- Secrecy risk contribution of partner country j to vulnerability of country i in channel k: Proportion of the total IFF risk that partner country j contributes to country i in a specific channel k. We combine the 𝑠𝑒𝑐𝑟𝑒𝑐𝑦 𝑟𝑖𝑠𝑘𝑗 of partner country j with the bilateral transaction volume between country i and partner country j in channel k using a cubic root formula. This formula has the advantage of exploiting the variance in both the risk and the transaction components while avoiding one of them dominating the other.

    ![image](https://github.com/user-attachments/assets/40727c51-960c-46af-904e-bf3a34fe8674)



