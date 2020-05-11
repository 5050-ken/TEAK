GENERAL INFORMATION:
---
In this folder you are going to find all the files related to the experimentations with the analogy based estimation (ABE) method called TEAK. Note that you will need to have MATLAB so as to be able to use these files. Furthermore, the execution and derivation files will try to write certain files under certain directories; make sure that you create the right directories. For the name of related directories, see the end of execution and derivation files.

-------------------------------------------------------

EXECUTION OF EXPERIMENTS:
---
There are two fundamental main files:

	* startPointWithLeaveOneOut.m
	* startPointWith10by3way.m

Depending on whether you want to use leave-one-out or 10-by-3 way cross-validation as your testing strategy, you may start executing one of the files.
Each file will then start processing the datasets that are specified right at the beginning of the files.
The results (estimations, actual effort values, performance measures) will then be saved as a MATLAB workspace under
related folders (see the end of file for related code line).

For more details regarding how function calls etc. are done, you will need to do some amount of code-walk.
The code is written in a self explanatory manner and is enriched with a substantial amount of comment.

-------------------------------------------------------

DERIVATION OF RESULTS:
---
The actual performance values are stored in terms of variables in MATLAB workspaces (see previous paragraphs).
So as to derive the win-tie-loss statistics out of these performance measures you will need to use the following MATLAB files:

	* winTieLossCalculator.m -> calculates win, tie, loss statistics for MdMRE
	* winTieLossCalculatorMAR.m -> calculates win, tie, loss statistics for MAR
	* winTieLossCalculatorPred25.m -> calculates win, tie, loss statistics for Pred25

Each one of the above functions will generate win, tie, loss statistics related to their own performance measure.
