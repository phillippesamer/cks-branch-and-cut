#!/usr/bin/env python
# -*- coding: utf-8 -*-

import random
import numpy
import networkx as nx
import matplotlib.pyplot as plt

import os

import math
from statistics import mean

def truncate(number, digits) -> float:
    nbDecimals = len(str(number).split('.')[1]) 
    if nbDecimals <= digits:
        return number
    stepper = 10.0 ** digits
    return math.trunc(stepper * number) / stepper

# five G(n,p) random graphs, for p in {0.01, 0.02, ..., 0.25}
n = 50
percentual_rates = range(10, 26, 5)      # q \in 1, 2, ..., 25 => p \in 0.01, 0.02, ... , 0.25
num_examples = 5
make_figures = False
destination_folder = "./g_np"

make_isolated_vertices_bad = True
isolated_vertex_weight = -99999

if not os.path.exists(destination_folder):
    os.makedirs(destination_folder)

seeds = [1092593, 1984337]
random.seed(seeds[0])
numpy.random.seed(seeds[1])

for q in percentual_rates:
    
    for iteration in range(num_examples):
        
        p = q / 100
        G = nx.erdos_renyi_graph(n, p)
        m = G.number_of_edges()
        
        #max_weight = 10
        #vertex_weights = random.sample(range(1, 101), n)        # all different
        #vertex_weights = [random.randint(-1*max_weight,max_weight) for u in range(n)]
        vertex_weights = [truncate(random.gauss(mu=0, sigma=1), 5) for u in range(n)]
        isolated_counter=0
        for u in range(n):
            if G.degree[u] == 0:
                isolated_counter = isolated_counter+1
                if make_isolated_vertices_bad:
                    vertex_weights[u] = isolated_vertex_weight
        neg = len([x for x in vertex_weights if x < 0])
        print(f"n = {n}, p = {p}, m = {m}, connected = {nx.is_connected(G)} ({isolated_counter} disconnected vertices), {neg} negative weight vertices")

        filepath = f"{destination_folder}/{n}-{q}-{iteration}"
        
        # save the graph to png file
        if make_figures:
            fig = plt.figure()
            nx.draw(G, with_labels=True, node_size=300)
            fig.savefig( filepath + ".png" )
            plt.close(fig)
        
        # create the .gcc file
        file = open(filepath + ".gcc", "w")
        file.write(f"# G_{n,p} (Erdos-Renyi) graph, with n = {n} and p = {p}\n")
        file.write(f"# Example {iteration} of {num_examples}\n")
        
        file.write(f"{filepath}\n")
        file.write(f"{n}\n")
        file.write(f"{m}\n")

        for i,j in G.edges:
            file.write(f"{i} {j}\n")

        for u in range(n):
            file.write(f"{vertex_weights[u]}\n")

        file.close()

# number of colours (constant for each combination of n,p)
"""
num_rates = len(percentual_rates)
num_components = [random.randint(2,11) for i in range(num_rates)]

file = open(destination_folder + "_colours.txt", "w")

for x in num_components:
    for i in range(5):
        file.write(f"{x}\n")

file.close()
"""
