import pandas as pd
from sklearn.tree import DecisionTreeClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from sklearn import tree
import graphviz 
import matplotlib.pyplot as plt

gameplay_data = pd.read_csv('Macroblocks_Dataset.csv')
features = gameplay_data.drop(columns=['X', 'Y', 'CLASS'])
output = gameplay_data['CLASS']
#print(features)
#print(output)
gameplay_data.info

features_train, features_test, output_train, output_test = train_test_split(features, output, test_size=0.5, random_state=2000, shuffle=True)
model = DecisionTreeClassifier(max_depth=10)
model.fit(features_train.values, output_train)
predictions = model.predict(features_test.values)
print(predictions)
print(output_test[0])
score = accuracy_score(output_test, predictions)
print("Accuracy: ", score)

fig, axes = plt.subplots(nrows=1, ncols=1, figsize= (10,10), dpi=2000)
_ = tree.plot_tree(model, feature_names=features_train.columns, class_names=['0', '1'], filled=True)
fig.savefig("tree.png")
#dot_data = tree.export_graphviz(model, out_file =None, feature_names= features_train.columns, class_names = ['No text', 'text'], filled = True, rounded=True, special_characters=True)
#graph = graphviz.Source(dot_data)
#graph.render("tree.png")
