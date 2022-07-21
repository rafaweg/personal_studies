import pandas as pd
import statistics
import matplotlib.pyplot as plt
import matplotlib.ticker as mticker
import seaborn as sb

import plotly.express as px
import plotly.offline as pyo #from plotly.offline import init_notebook_mode, iplot
import plotly.graph_objs as go
from plotly.subplots import make_subplots

# Inicializando o modo offiline do plotly 
pyo.init_notebook_mode(connected=True)

df = pd.read_csv('gs://athena-tmp/rafa/vendas_empresa.csv')

df.quantile(q = 0.1)

df.describe()

fig = px.box(df,
             y = 'vendas'
            )

fig.show()

fig = px.histogram(df,
                   x = 'vendas',
                   nbins = 50
                  )

fig.show()

