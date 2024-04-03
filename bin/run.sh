#! /bin/sh

root="/opt/test-runner"
export PYTHONPATH="$root:$PYTHONPATH"

mkdir autograding_output

while [ $# -gt 0 ]; do
  case "$1" in
    --timeout=*)
      TIMEOUT="${1#*=}"
      ;;
    --max-score=*)
      MAX_SCORE="${1#*=}"
      MAX_SCORE="${MAX_SCORE:-0}"
      ;;
    --setup-command=*)
      SETUP_COMMAND="${1#*=}"
      ;;
    *)
      printf "***************************\n"
      printf "* Warning: Unknown argument.*\n"
      printf "***************************\n"
  esac
  shift
done

TIMEOUT=$((TIMEOUT * 60))
echo "TIMEOUT is $TIMEOUT seconds"
echo "MAX_SCORE is $MAX_SCORE"

timeout "$TIMEOUT" python3 bin/run.py ./ ./autograding_output/ "$MAX_SCORE"
exit_status=$?
if [ $exit_status -eq 124 ]; then
  echo "The command took longer than $TIMEOUT seconds to execute. Please increase the timeout to avoid this error."
  echo '{"status": "error", "message": "The command timed out"}' > autograding_output/results.json
fi

echo "result=$(jq -c . autograding_output/results.json | jq -sRr @base64)" >> "$GITHUB_OUTPUT"
