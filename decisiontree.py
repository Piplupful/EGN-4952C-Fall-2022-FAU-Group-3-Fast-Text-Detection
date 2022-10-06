import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn import tree
import graphviz 
import matplotlib.pyplot as plt
import pickle
from sklearn.tree import export_text

gameplay_data = pd.read_csv('Macroblocks_Dataset.csv')
#print(gameplay_data.head)
features = gameplay_data.drop(columns=['X', 'Y', 'CLASS'])
#print(features.head)
output = gameplay_data['CLASS']
#print(output.head)

feature_names = ['AVGQUADRANT_MACRO_VALUE', 'AVG_MACRO_VALUE' , 'RANGE_MACRO_VALUE' , 'MAX_MACRO_VALUE' , 'MIN_MACRO_VALUE']
#print(features)
#print(output)
gameplay_data.info

features_train, features_test, output_train, output_test = train_test_split(features, output, test_size=0.5, random_state=2000, shuffle=True)
#print(features_train.head)
#print(output_train)
#print(features_test.head)
#print(output_test.head)

model = DecisionTreeClassifier(max_depth=6)
#model = DecisionTreeClassifier()
#model = DecisionTreeClassifier(max_depth=10)
#model = DecisionTreeClassifier(max_depth=20)

model.fit(features_train.values, output_train)
predictions = model.predict(features_test.values)
print(predictions)
print(output_test[0])
score = accuracy_score(output_test, predictions)
print("Accuracy before loading DTC: ", score)

fig, axes = plt.subplots(nrows=1, ncols=1, figsize= (4,4), dpi=2000)
_ = tree.plot_tree(model, feature_names=features_train.columns, class_names=['0', '1'], filled=True)
fig.savefig("tree.png")
#dot_data = tree.export_graphviz(model, out_file =None, feature_names= features_train.columns, class_names = ['No text', 'text'], filled = True, rounded=True, special_characters=True)
#graph = graphviz.Source(dot_data)
#graph.render("tree.png")

r = export_text(model, feature_names= feature_names, max_depth=6)

with open('DTC.txt', 'w') as f:
    f.write(r)
# Dump the trained decision tree classifier with Pickle
#filename = 'DTC-09-29-22.pkl'
# Open the file to save as pkl file
#DTC_pkl = open(filename, 'wb')
#pickle.dump(model, DTC_pkl)
# Close the pickle instances
#DTC_pkl.close()
#print("In between transfer")

#DTC_load_pkl = open(filename, 'rb')
#DTC_load_model = pickle.load(DTC_load_pkl)

#loaded_predictions = DTC_load_model.predict(features_test.values)
#print(loaded_predictions)
#new_score = accuracy_score(output_test, loaded_predictions)
#print("Accuracy after loading DTC: ", new_score
