logdir=tmp_log

rm -rf ./$logdir
mkdir ./$logdir
echo "Formatting json_serializable_generator..."
dartfmt lib/*.dart -w > ./$logdir/dartfmt.log
dartfmt lib/**/*.dart -w >> ./$logdir/dartfmt.log

dartdoc > ./$logdir/dartdoc.log
echo "Testing json_serializable_generator..."
pub run build_runner test > ./$logdir/test.log
echo "Analyzing json_serializable_generator..."
dartanalyzer --options analysis_options.yaml . > ./$logdir/dartanalyzer.log
