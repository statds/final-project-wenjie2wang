iter := {1..2}
test_data := test-data/$(iter).csv
test_coxCure := test-coxCure/$(iter).RData
test_rsf := test-rsf/$(iter).RData
test_deepSurv := test-deepSurv/$(iter).csv


## test all and do cleaning
.PHONY: all
all: data coxCure rsf deepSurv clean

## test all but not do cleaning
.PHONY: test
test: data coxCure rsf deepSurv

.PHONY: data
data: $(test_data)

$(test_data): test-data.R ../simulation/simu-fun.R
	@./$<
	@printf "[$$(date)]: Testing data were generated.\n"

.PHONY: coxCure
coxCure: $(test_coxCure)

$(test_coxCure): test-coxCure.R test-coxCure.sh
	@bash test-coxCure.sh

.PHONY: rsf
rsf: $(test_rsf)

$(test_rsf): test-rsf.R test-rsf.sh
	@bash test-rsf.sh

.PHONY: deepSurv
deepSurv: $(test_deepSurv)

$(test_deepSurv): test-deepSurv.py test-deepSurv.sh
	@bash test-deepSurv.sh

.PHONY: Tensorboard
Tensorboard:
	tensorboard --logdir deepSurv_logs/tensorboard/ &> /dev/null

.PHONY: clean
clean:
	@rm -rf deepSurv_logs/ test-data/ test-coxCure/ test-rsf/ test-deepSurv/
	@printf "[$$(date)]: Cleaned all logs and testing results.\n"
