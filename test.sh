#!/bin/sh
set -eu

echo "Running repo-local test patch: test.sh"

# This test script is intentionally small and safe to run locally.
# It checks that a Dockerfile exists and that the first FROM line
# uses one of the accepted public ECR base images required by the validator.

if [ ! -f Dockerfile ]; then
  echo "FAIL: Dockerfile not found in repository root."
  exit 1
fi

# extract the first FROM image token (the second field after FROM)
first_from=$(grep -i '^FROM ' Dockerfile | head -n1 | awk '{print $2}' || true)

if [ -z "${first_from}" ]; then
  echo "FAIL: could not find a FROM line in Dockerfile."
  exit 1
fi

echo "Detected first FROM: ${first_from}"

# Allowed prefixes/patterns (keep in sync with validator guidance)
case "${first_from}" in
  public.ecr.aws/x8v8d7g8/mars-base:* )
    echo "OK: matches mars-base allowed pattern" ;;
  public.ecr.aws/d3j8x8q7/olympus-base* )
    echo "OK: matches olympus-base allowed pattern" ;;
  public.ecr.aws/d3j8x8q7/olympus-base-cpp* )
    echo "OK: matches olympus-base-cpp allowed pattern" ;;
  public.ecr.aws/d3j8x8q7/olympus-base-python* )
    echo "OK: matches olympus per-language pattern" ;;
  * )
    echo "FAIL: Dockerfile base image is not an accepted public ECR olympus/mars base." ;
    echo "Accepted examples: public.ecr.aws/x8v8d7g8/mars-base:latest or public.ecr.aws/d3j8x8q7/olympus-base:latest or per-language olympus-base-cpp:latest" ;
    echo "You can still run: sh test.sh to see this check locally." ;
    exit 1 ;;
esac

# Additional optional checks (non-fatal): presence of expected binary path or recommended CMD
if grep -qi 'CMD \["your_app"\]' Dockerfile || grep -qi "COPY --from=builder /app/your_app /app/your_app" Dockerfile ; then
  echo "Info: Dockerfile appears aligned with the /app/your_app / CMD [\"your_app\"] pattern used by tests."
else
  echo "Info: Dockerfile does not appear to copy /app/your_app or set CMD [\"your_app\"] — ensure this matches your grader expectations if needed." >&2
fi

echo "test.sh: basic checks passed."
exit 0
