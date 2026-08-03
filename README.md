# cultural-transmission and the emergence of compositionality


This repository contains the code, and a Jupyter Notebook to generate the plots for the paper *"How Cultural Transmission Shapes Compositionality: A Unified Study with a Bayesian Agent-Based Model"*  

---

### Experiments

| Experiment | Title |
|-------------|--------|
| 1 | Social Network Structure |
| 2 | Transmission Modes |
| 3 | Population Size |
| 4 | Rate of Replacement |

---

## Running Simulations

A single simulation (for example, Experiment 2: *Transmission Modes*) can be executed using:

```bash
python sim_extra.py --mode "sample" --group_round 50 --turnover_round 0 --pop_size 25 --run_id 5 --network_type "fully-connected" --replace True --alpha 0.0
```

---

## Reproducing Experiments
A batch run can be done by running the batch_run.sh. Make sure to change line in the script to the desired parameters.txt and python file.
Parameter txt-files can be created using the Jupyter notebook:

```
get_params.ipynb
```
---



