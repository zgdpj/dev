truncate table dtm_prod.pack_qty;

copy dtm_prod.pack_qty from 's3://bi-data-us/PACK_QTY/PACK_QTY.csv.gz' CREDENTIALS 'aws_access_key_id=AKIAJ67WWAE5PDGKFOMQ;aws_secret_access_key=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' delimiter ';' GZIP IGNOREHEADER 1;
