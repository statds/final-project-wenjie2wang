iter := {1..2}
test_data := test-data/$(iter).csv
test_coxCure := test-coxCure/$(iter).RData
test_rsf := test-rsf/$(iter).RData
test_deepSurv := test-deepSurv/$(iter).csv


## test all but not do cleaning
.PHONY: all
all: coxCure rsf deepSurv

.PHONY: data
data: $(test_data)

$(test_data): test-data.R ../simulation/simu-fun.R
	@./$<
	@printf "[$$(date)]: Testing data were generated.\n"

.PHONY: coxCure
coxCure: $(test_coxCure)

$(test_coxCure): test-coxCure.R test-coxCure.sh $(test_data)
	@bash test-coxCure.sh

.PHONY: rsf
rsf: $(test_rsf)

$(test_rsf): test-rsf.R test-rsf.sh $(test_data)
	@bash test-rsf.sh

.PHONY: deepSurv
deepSurv: $(test_deepSurv)

$(test_deepSurv): test-deepSurv.py test-deepSurv.sh $(test_data)
	@bash test-deepSurv.sh

.PHONY: Tensorboard
Tensorboard:
	tensorboard --logdir deepSurv_logs/tensorboard/ &> /dev/null

.PHONY: clean
clean:
	@rm -rf deepSurv_logs/ test-data/ test-coxCure/ test-rsf/ test-deepSurv/
	@printf "[$$(date)]: Cleaned all logs and testing results.\n"
