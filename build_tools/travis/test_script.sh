#!/bin/bash
# This script is meant to be called by the "script" step defined in
# .travis.yml. See http://docs.travis-ci.com/ for more details.
# The behavior of the script is controlled by environment variabled defined
# in the .travis.yml in the top level folder of the project.

# License: 3-clause BSD

set -e

# Get into a temp directory to run test from the installed scikit learn and
# check if we do not leave artifacts
mkdir -p $TEST_DIR
# We need the setup.cfg for the nose settings
cp setup.cfg $TEST_DIR
cd $TEST_DIR

python --version
python -c "import numpy; print('numpy %s' % numpy.__version__)"
python -c "import scipy; print('scipy %s' % scipy.__version__)"
python -c "import multiprocessing as mp; print('%d CPUs' % mp.cpu_count())"

if [[ "$COVERAGE" == "true" ]]; then
   nosetests -s --with-coverage --with-timer --timer-top-n 20 skcycling
else
   nosetests -s --with-timer --timer-top-n 20 skcycling
fi

# Is directory still empty ?
ls -ltra

# # Test doc
# cd $CACHED_BUILD_DIR/scikit-cycling
# make test-doc test-sphinxext
