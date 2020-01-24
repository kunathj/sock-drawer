# Version controlling for notebooks

Jupyter notebooks are a great tool for interactive code production and data
exploration, especially for an interplay with graphic output.
Their output is saved inside the `.ipynb` file, making them a nightmare for
version controlling if no pre-processing is applied.
Two approaches that facilitate working with notebooks for git version
controlling are presented below.
To be honest, I did not investigate yet what are git filters and 
hooks. All I can really say so far is: 
The first approach should be favored.

## Employ a git filter

Ideally we would want git to ignore the output in the notebook files while
keeping the output locally.
Filters are applied to files before they are added.
A filter would thus be the perfect solution:
Git will only notice changes if the actual code changes, and not if the output
is altered due to rerunning some cells.
An easy-to-use implementation of this concept is
[`nbstripout`](https://github.com/kynan/nbstripout).
So far, this approach worked perfectly for me. After being set up for a project
it reliably removed any output from my notebook files, including widget states.
The only downside with this solution is that all collaborators need
`nbstripout` set up on their machine if they want to contribute code.
The setup is as easy as:

- Install the package with your favorite python package management system:
  `conda install -c conda-forge nbstripout` or `pip install nbstripout`.
- Install the git hook in the current repository: `nbstripout --install`.

## Employ a git hook

Before discovering the above solution, I worked with setting a git pre-commit
hook.
One solution would have been to have the hook remove any output from the
notebooks that are going to be committed.

Instead, I opted for showing a dialog window that asks you to confirm that you
want to execute this commit even thought there is a notebook with output in the
commit.
This means that the output has to be stripped out *by hand* (or with
another script) and that we will have to trigger the commit again if we decide
to change the notebook files.
While this leads to some extra steps, it avoids accidentally deleting output.
As this output could be the result of time-consuming computations we might want
to save it into an external file before removing it from the notebook.

The hook could have a simpler form if all version controlling in the projet is
done from the command line.
Some extra steps were necessary to make this dialog-triggering hook work with
the built-in git extension of VS Code.
Two scripts must be added into the `.git/hooks` folder:

- `pre-commit` and
- `proceed_or_not` (make sure this script is made executable).

Note that you have the choice of employing this hook for one project or
user-wide.
