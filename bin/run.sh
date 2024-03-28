#! /bin/sh

root="/opt/test-runner"
export PYTHONPATH="$root:$PYTHONPATH"

mkdir autograding_output

TIMEOUT="$1"
MAX_SCORE="${2:-0}"
SETUP_COMMAND="$3"

if [ -n "$SETUP_COMMAND" ]; then
  $SETUP_COMMAND
fi

python3 /opt/test-runner/bin/run.py ./ ./autograding_output/ "$MAX_SCORE" "$TIMEOUT"

echo "result=$(jq -c . autograding_output/results.json | jq -sRr @base64)" >> "$GITHUB_OUTPUT"
