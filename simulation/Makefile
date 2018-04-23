iter := {1..1000}
simu_data := simu-data/$(iter).csv
fit_coxCure := fit-coxCure/$(iter).RData
fit_rsf := fit-rsf/$(iter).RData
fit_deepSurv := fit-deepSurv/$(iter).csv


## simulating all models
.PHONY: all
all:
	nohup $(MAKE) simulation &> nohup.out &

.PHONY: simulation
simulation: data coxCure rsf deepSurv

.PHONY: data
data: $(simu_data)

$(simu_data): simu-data.R simu-fun.R
	@./$<
	@printf "[$$(date)]: All simulation data were generated.\n"

.PHONY: coxCure
coxCure: $(fit_coxCure)

$(fit_coxCure): fit-coxCure.R fit-coxCure.sh
	@bash fit-coxCure.sh 1> fit-coxCure.log 2> /dev/null

.PHONY: rsf
rsf: $(fit_rsf)

$(fit_rsf): fit-rsf.R fit-rsf.sh
	@bash fit-rsf.sh 1> fit-rsf.log 2> /dev/null

.PHONY: deepSurv
deepSurv: $(fit_deepSurv)

$(fit_deepSurv): fit-deepSurv.py fit-deepSurv.sh
	@bash fit-deepSurv.sh &> fit-deepSurv.log

.PHONY: Tensorboard
Tensorboard:
	tensorboard --logdir deepSurv_logs/tensorboard/ &> /dev/null

.PHONY: clean
clean:
	@rm -rf *~ *.log nohup.out
	@printf "[$$(date)]: Cleaned all logs and temp files.\n"

.PHONY: cleanAll
cleanAll: clean
	@rm -rf deepSurv_logs/ simu-data/ fit-coxCure/ fit-rsf/ fit-deepSurv/
	@printf "[$$(date)]: Cleaned simulation results.\n"
