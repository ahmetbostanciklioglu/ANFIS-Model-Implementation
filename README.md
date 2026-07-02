<div align="center">

# 🧠 ANFIS Model Implementation

**Adaptive Neuro-Fuzzy Inference System models in MATLAB for predicting the dielectric behavior of a material from temperature and frequency.**

![MATLAB](https://img.shields.io/badge/MATLAB-R2020b%2B-orange?style=flat-square&logo=mathworks)
![Simulink](https://img.shields.io/badge/Simulink-Model-blue?style=flat-square)
![Fuzzy Logic Toolbox](https://img.shields.io/badge/Fuzzy%20Logic%20Toolbox-required-6E48AA?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-4776E6?style=flat-square)
![Stars](https://img.shields.io/github/stars/ahmetbostanciklioglu/ANFIS-Model-Implementation?style=flat-square&color=6E48AA)
![Last Commit](https://img.shields.io/github/last-commit/ahmetbostanciklioglu/ANFIS-Model-Implementation?style=flat-square&color=4776E6)

</div>

## 📖 Overview

This repository implements two **ANFIS** (Adaptive Neuro-Fuzzy Inference System) models in MATLAB that predict the relative permittivity (`eps`) and the tangent loss (`tnd`) of a material as functions of **temperature** and **frequency**. The models are trained on tabulated experimental data and then combined to reproduce the frequency-versus-loss curves and the Simulink-style user interface presented in the accompanying research article (`Article.pdf`).

Each model is built with grid partitioning and generalized bell membership functions, trained with the hybrid ANFIS learning rule, and used to regenerate the article's Figure 9 (a simulation interface) and Figure 10 (frequency vs. `Tloss` graphs at several temperatures).

## ✨ Features

- **Two coupled ANFIS models** — one for permittivity (`eps`), one for tangent loss (`tnd`) — trained from `Train_data.xlsx` with temperature and frequency inputs.
- **Grid-partition FIS generation** using 5 generalized-bell membership functions per input (`gbellmf`), producing 25 rules per model, matching the article's methodology.
- **Hybrid ANFIS training** with configurable epochs (5000 for `eps`, 500 for `tnd`) via `anfisOptions`.
- **Figure 10 reproduction** (`Anfis_simulinks.m`) — computes `Tloss = eps · frequency · tanδ` and plots it across a 50 Hz–10 kHz sweep for 20/50/80 °C.
- **Figure 9 reproduction** (`fig_9.m`) — draws a Simulink-style block diagram with gains, a mux, ANFIS blocks, and live predicted outputs.
- **Bundled Simulink model** (`fig9.slx`) and saved figure (`Anfis_Simulink-figure-10.fig`) plus the source article for full reproducibility.

## 📸 Preview

<div align="center">

<img width="1034" height="441" alt="ANFIS Simulink interface" src="https://github.com/user-attachments/assets/f63f55b0-8aa6-4a5b-84ad-70455172f282" />

<img width="1411" height="912" alt="Fig-10 frequency vs Tloss graph" src="https://github.com/user-attachments/assets/c27d4982-b271-417e-a52b-d14bf7b9b18b" />

</div>

## 🚀 Getting Started

```bash
git clone https://github.com/ahmetbostanciklioglu/ANFIS-Model-Implementation.git
cd ANFIS-Model-Implementation
```

Then, in MATLAB, make sure the repository folder is the current working directory (so the `.xlsx` data files are on the path) and run either script:

```matlab
% Train the models and reproduce Figure 10 (frequency vs. Tloss)
Anfis_simulinks

% Train the models and reproduce Figure 9 (Simulink-style interface)
fig_9
```

To explore the Simulink model directly, open `fig9.slx` in Simulink.

## 📋 Requirements

- **MATLAB** R2020b or later
- **Fuzzy Logic Toolbox** (for `genfis`, `genfisOptions`, `anfis`, `anfisOptions`, `evalfis`)
- **Simulink** (only to open `fig9.slx`)
- The provided data files `Train_data.xlsx` and `Testing_data.xlsx` on the MATLAB path

## 🧑‍💻 Author

**Ahmet Bostancıklıoğlu** — [@ahmetbostanciklioglu](https://github.com/ahmetbostanciklioglu) · ahmetbostancikli@gmail.com

> ⭐ If this helped you, consider giving the repo a star!
