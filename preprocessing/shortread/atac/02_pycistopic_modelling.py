import pycisTopic
import pandas as pd
import pickle
import os

os.chdir(os.getcwd())

out_dir = "outs"
os.makedirs(out_dir, exist_ok = True)

file_path = "/preprocessing/shortread/atac/outs/cistopic_obj.pkl"
with open(file_path, 'rb') as file:
    cistopic_obj = pickle.load(file)

print(cistopic_obj)


os.environ['MALLET_MEMORY'] = '250G'
from pycisTopic.lda_models import run_cgs_models_mallet
# Configure path Mallet
mallet_path="Mallet-202108/bin/mallet"
# Run models
models=run_cgs_models_mallet(
    cistopic_obj,
    n_topics=[2, 5, 10, 15, 20],
    n_cpu=30,
    n_iter=500,
    random_state=555,
    alpha=50,
    alpha_by_topic=True,
    eta=0.1,
    eta_by_topic=False,
    tmp_path="/ray_spill/mallet/tutorial2",
    save_path="/ray_spill/mallet/tutorial2",
    mallet_path=mallet_path,
)

pickle.dump(
    models,
    open(os.path.join(out_dir, "models.pkl"), "wb")
)
