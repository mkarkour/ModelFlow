- modeling_results_viewer.ipynb
   1. Reorganise the notebook to be more readable (first show the metadata, then the models and queries, then the tests, then the ERDs, then the data previews)
   2. Add a summary of the results at the end
   3. Improve the ERDs to show the relationships between the models and fix the visualisation issues

- models/
   1. Add better comment to guide final user write the query
   2. the missing models sql for the exercise section based on the models in the solution section
   3. Add the possibility to build one python model per modelisation technique in the exercice section and add the solution in the solution section
   4. Remove any piece of code, left only the comments, uniformise all the other models in the exercise section that still have code or no good comments to guide the user.

- README.md
   1. Improve the file to add a dbt debug so the user can test the connection before starting to build the models
