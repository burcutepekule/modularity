# Modularity

This repository contains the code for the blog post **"Happy Little Local Minimum"**.

## Overview

This project allows you to run simulations for modularly varying goals (MVG) and observe how networks evolve over time, based on Kashtan et al., 2005, PNAS.

## Usage

You can use the `runSeed` function to run your own simulation:

```matlab
runSeed(seed, numSims, numOfInputs, mutProb, numOfGatesVec, onlyChangeConnections, freqAlternate, MVG)
```

Every 5 iterations are saved as a `.mat` file in `./local_output/freq_$freqAlternate/`, and the filename will contain information about the seed, number of inputs, frequency alternation, and MVG setting.

### Parameters

| Parameter | Description |
|-----------|-------------|
| `seed` | Random seed for your run |
| `numSims` | Number of generations |
| `numOfInputs` | Number of inputs |
| `mutProb` | Mutation probability |
| `numOfGatesVec` | Binary input (0 or 1) to set a fixed circuit size when initiating the first population of networks |
| `onlyChangeConnections` | Binary input (0 or 1) to either have mutations to add and remove gates on top of changing connections |
| `freqAlternate` | Epoch duration, or the number of generations the circuit spends evolving under one environment |
| `MVG` | Binary input (0 or 1) to use either a constant environment or modularly varying goals environment |

## Generating GIFs

Once the matrices are saved, you can generate your own GIF file using the `GIF_local.m` script. 

**Note:** This script takes a bit of time to find the best possible allocation of gates for an interpretable visualisation, so not the fastest code ever - but the output does look nice at least :) 

## Example

Here's an example of the output from a simulation:

![Example Simulation]([https://raw.githubusercontent.com/username/modularity/main/example.gif](https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhkOJYoSRGrhfi8vxstYvST8ep2VUkACknUPOa8Z8tgaj1iqz2bBqpj3_3gLNPFQUXiKAc0JXdER1hIgsXKuYKISxCsUCdXGv_QtbfeV6hqQnbAIkDpE-wO8x_wi3APyWR_YOxmO21wjpPCXYFvq8OPW2HxzSKJFgFbkPwRQ1gPNd8jpa1J2sYaeVl5YzpD/s1600/circuitsAnimated_MVG_SEED_9-ezgif.com-speed.gif))

## Contributing

Sorry for how lame and terribly slow the code is :D if anybody is up for optimizing it, they are welcome!
