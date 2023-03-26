dir=$(dirname "$0")

printf "Testing the following regex for known usecases\n"
melody "$dir/latex_size.melody"
printf "\n"

while IFS= read -r line; do
  melody --test "$line" "$dir/latex_size.melody"
done < "$dir/test_strings_latex_size.txt"
