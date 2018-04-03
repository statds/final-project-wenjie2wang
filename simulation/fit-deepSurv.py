###############################################################################
# fitting the DeepSurv model
# version controlled by git
###############################################################################


# read in arguments from command line
import sys
train_id = int(sys.argv[1])
if train_id is 1:
    test_id = 1000
else:
    test_id = train_id - 1

# import module deep_surv and other modules
sys.path.append('DeepSurv/deepsurv')
import deep_surv
from deepsurv_logger import DeepSurvLogger, TensorboardLogger
import utils
import viz

import os
import numpy as np
import pandas as pd

import lasagne
# import matplotlib
# import matplotlib.pyplot as plt


# read in the training and testing dataset
in_dir = 'simu-data/'
train_dataset_fp = in_dir + str(train_id) + '.csv'
test_dataset_fp = in_dir + str(test_id) + '.csv'
train_df = pd.read_csv(train_dataset_fp)
test_df = pd.read_csv(test_dataset_fp)


# Transform the dataset to "DeepSurv" format
# DeepSurv expects a dataset to be in the form:
#     {
#         'x': numpy array of float32
#         'e': numpy array of int32
#         't': numpy array of float32
#         'hr': (optional) numpy array of float32
#     }
def dataframe_to_deepsurv_ds(df, event_col = 'Event', time_col = 'Time'):
    # Extract the event and time columns as numpy arrays
    e = df[event_col].values.astype(np.int32)
    t = df[time_col].values.astype(np.float32)

    # Extract the patient's covariates as a numpy array
    x_df = df.drop([event_col, time_col], axis = 1)
    x = x_df.values.astype(np.float32)

    # Return the deep surv dataframe
    return {
        'x': x,
        'e': e,
        't': t
    }


# prepared training dataset
train_data = dataframe_to_deepsurv_ds(train_df)
test_data = dataframe_to_deepsurv_ds(test_df)


# list of hyperparameters
hyperparams = {
    'L2_reg': 10.0,
    'batch_norm': True,
    'dropout': 0.4,
    'hidden_layers_sizes': [25, 25],
    'learning_rate': 1e-05,
    'lr_decay': 0.001,
    'momentum': 0.9,
    'n_in': train_data['x'].shape[1],
    'standardize': True
}

# enable tensorboard
experiment_name = 'test_experiment_sebastian'
logdir = 'logs/tensorboard/'
logger = TensorboardLogger(experiment_name, logdir = logdir)

# create an instance of DeepSurv using the hyperparams defined above
model = deep_surv.DeepSurv(**hyperparams)

# the type of optimizer to use
update_fn = lasagne.updates.nesterov_momentum
# check out http://lasagne.readthedocs.io/en/latest/modules/updates.html
# for other optimizers to use

n_epochs = 2001

# train the model
metrics = model.train(train_data, test_data, n_epochs = n_epochs,
                      logger = logger, update_fn = update_fn)

# Print the final metrics
print('Train C-Index:', metrics['c-index'][-1])
print('Test C-Index:', metrics['valid_c-index'][-1])

# save the results to csv files
out_dir = 'fit-deepSurv'
if not os.path.exists(out_dir):
    os.makedirs(out_dir)

out_file = out_dir + '/' + str(train_id) + '.csv'
out_df = pd.DataFrame({
    'train_cStat': [metrics['c-index'][-1][1]],
    'test_cStat': [metrics['valid_c-index'][-1][1]]
})
out_df.to_csv(out_file, index = False)
