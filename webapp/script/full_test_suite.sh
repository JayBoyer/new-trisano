#!/bin/sh


echo "*************************************"
read -r -p "Are you sure you are ready to run all tests? [Y/n] " response

case $response in
  [Y]) 

    rm log/test.log
    rm log/feature.log

    echo ">>>>>>>>>>Stopping enhanced environment"
    ./script/enhanced_support_stop.sh

    echo ">>>>>>>>>>Reset DB, output to log/dbreset.log"
    time bundle exec rake db:reset 2>&1 | tee ./log/dbreset.log

    echo ">>>>>>>>>>Running specs, output to log/spec.log"
    time bundle exec rake spec 2>&1 | tee ./log/spec.log

    echo ">>>>>>>>>>Running standard features, output to log/standard_features.log"
    time bundle exec rake features 2>&1 | tee ./log/standard_features.log

    echo ">>>>>>>>>>Setting up enhanced support infrastructure"
# comment out until enhanced_features tests can run successfully
#    ./script/enhanced_support.sh

    echo ">>>>>>>>>>Running enhanced features, output to log/enhanced_features.log"
# comment out until enhanced_features tests can run successfully
#    time bundle exec rake enhanced_features 2>&1 | tee ./log/enhanced_features.log

;;
esac
