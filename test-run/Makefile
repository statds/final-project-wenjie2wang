test_data := test-data/1.csv test-data/2.csv
test_coxCure := test-coxCure/1.RData test-coxCure/2.RData
test_rsf := test-rsf/1.RData test-rsf/2.RData
test_deepSurv := test-deepSurv/1.csv


## test all and do cleaning
.PHONY: all
all: data coxCure rsf deepSurv clean

## test all but not do cleaning
.PHONY: test
test: data coxCure rsf deepSurv

.PHONY: data
data: $(test_data)

$(test_data): test-data.R
	@./$<
	@printf "[$$(date)]: Testing data were generated.\n\n"

.PHONY: coxCure
coxCure: $(test_coxCure)

$(test_coxCure): test-coxCure.R
	@bash test-coxCure.sh

.PHONY: rsf
rsf: $(test_rsf)

$(test_rsf): test-rsf.R
	@bash test-rsf.sh

.PHONY: deepSurv
deepSurv: $(test_deepSurv)

$(test_deepSurv): test-deepSurv.py
	@bash test-deepSurv.sh

.PHONY: clean
clean:
	@rm -rf deepSurv_logs/ test-data/ test-coxCure/ test-rsf/ test-deepSurv/
	@printf "[$$(date)]: Cleaned all logs and testing results.\n\n"
