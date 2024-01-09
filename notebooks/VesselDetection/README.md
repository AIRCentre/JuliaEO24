
# Maritime Surveillance with Satellites and Artificial  Intelligence Workshop


## Overview
This repository contains the Julia notebooks and resources for the workshop on Maritime Surveillance with Satellites and Artificial  Intelligence for JuliaEO2024.  The project utilizes Julia for processing and analyzing satellite data and identifying vessels

## Getting Started

### Prerequisites
- Julia, tested on 1.9
- `VesselDetection.jl`, can be download from https://github.com/aalling93/VesselDetection.jl
-  Some plotting functionalites does not work for Julia<1.8
- Assumes `Makie`, `GLMakie`, and `Plots` are available for plotting, else
    - using Pkg; Pkg.add(["Makie","GLMakie","Plots", "Images"])

### Installation
- Clone this repository or download the ZIP file.
- Navigate to the project directory and install `VesselDetection.jl`.

### Structure
The project is structured as follows:
- `Notebooks`: Contains the Jupyter notebooks for the workshops.
    - 1: [Sentinel-1 data acquisition](Notebooks/1_Data_acqusition.ipynb)
    - 2: [Ship binary classification](Notebooks/2_Ship_binary_classification.ipynb)
    - 3: [Two stage ship detection](Notebooks/3_two_stage_ship_detector.ipynb)
    - 4: [One stage ship detection](Notebooks/4_One_stage_ship_detector.ipynb)
- `Theory`: Includes few notebooks and materials explaining the theoretical background.
- `data`: Directory containing the satellite data and training models.
    - `Model`: Contains a trained classifier and a trained one-stage ship detector.
    - `S1A_IW_GRDH_1SDV_20220612T173329_20220612T173354_043633_05359A_EA25.SAFE`: An example of a full Sentinel-1 VV/VH IW GRD image
    - `S1A_IW_GRDH_1SDV_20220612T173329_20220612T173354_043633_05359A_EA25_test.SAFE`: An subset of a Sentinel-1 VV/VH IW GRD image with ship.
    - `train.json`: dataset for training the classifier. Contains image chips of ships or icebergs. 

### Notebooks
Navigate to the `Notebooks` directory to access the Jupyter notebooks:
1. `1_Data_acquisition.ipynb`: Guide to acquiring and preprocessing satellite data.
2. `2_Ship_binary_classification.ipynb`: Notebook for binary classification of ships.
3. `3_two_stage_ship_detector.ipynb`: Implementation of a two-stage ship detection algorithm.
4. `4_One_stage_ship_detector.ipynb`: Implementation of a one-stage ship detection model.


## Usage
To use this repository effectively:
1. Set up your Julia environment with the necessary packages.
2. Explore the `Notebooks` for practical implementations.
3. For theoretical background, refer to the `Theory` folder.
4. Ensure the `VesselDetection.jl` module is added to your environment.
