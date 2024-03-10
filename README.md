# COVID-19 Impact on Mental Health Analysis

## Overview

This repository hosts the R code for a group project in IPAC 4130.

This project investigates the changes in depression and anxiety among Americans from March 2020 to January 2021, during the COVID-19 pandemic. The aim is to understand how the pandemic has affected mental health to better shape mental health services and prepare for future pandemics.

## Rationale

The COVID-19 pandemic has led to unprecedented changes in daily life, including national lockdowns and significant workforce disruptions. These changes have the potential to impact mental health significantly. By analyzing these impacts, we can increase our knowledge and awareness about depression and anxiety, helping to inform future mental health services and policies.

## Problem Statement

While previous studies have identified that certain subgroups experienced disproportionately worse mental health outcomes during the pandemic, this project seeks to explore additional subgroups. Specifically, we aim to determine if and how depression and anxiety levels have changed since 2019 due to the COVID-19 pandemic.

## Data Source

The data for this analysis was sourced from the Household Pulse Survey (HPS), conducted by the United States Census Bureau. The HPS is a rich dataset covering a wide range of topics, including mental health, which is the focus of our project. We utilized data from three key periods during the first phase of data collection:

- **Week 1:** April 23-May 5
- **Week 15:** September 16-September 28
- **Week 21:** December 9-December 21

## Methodology

Our analysis involved a quantitative comparative approach, focusing on variables such as age, gender, and geographic location to illustrate changes in the mental health state of the American population over an 8-month period. We performed logistic regression to model the probability of being diagnosed with anxiety or depression, considering factors such as the week into the COVID-19 lockdown, race, income, and work loss.

## Key Findings

The logistic regression analysis revealed a gradual increase in mental health issues as the pandemic progressed, with the odds of being diagnosed with anxiety or depression increasing by a factor of 1.005 for each additional week into the COVID-19 lockdown.

Visualizations generated from the logistic model provided further insights into how the probability of being diagnosed with anxiety or depression varied over time and across different subgroups, controlled for various factors.

## Conclusion

This project highlights the significant impact of the COVID-19 pandemic on mental health, underscoring the need for targeted mental health services and policies to address the needs of those most affected by the pandemic.

## References

- Fields JF, Hunter-Childs J, Tersine A, Sisson J, Parker E, Velkoff V, Logan C, and Shin H. Design and Operation of the 2020 Household Pulse Survey, 2020. U.S. Census Bureau. Forthcoming.
- Czeisler, M. É., Lane, R. I., Petrosky, E., Wiley, J. F., Christensen, A., Njai, R., Weaver, M. D., Robbins, R., Facer-Childs, E. R., Barger, L. K., Czeisler, C. A., Howard, M. E., & Rajaratnam, S. M. W. (2020). Mental Health, Substance Use, and Suicidal Ideation During the COVID-19 Pandemic — United States, June 24–30, 2020. MMWR. Morbidity and Mortality Weekly Report, 69(32), 1049–1057. https://doi.org/10.15585/mmwr.mm6932a1
