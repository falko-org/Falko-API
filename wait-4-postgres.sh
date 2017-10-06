shift 2

while ! pg_isready -h falko-database -p 5432 -q -U postgres; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"

