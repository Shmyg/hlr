sed -n '/CRMSUB/s/.*MSIN=\([0-9]\{10\}\).*PHON-\([0-9]\{6\}\).*NDC=\([0-9]\{2\}\).*/\1;\2;\3/p' $1 > hlr_customers.txt
