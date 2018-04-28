iter := {1..1000}
simu_data := simu-data/$(iter).csv
fit_coxCure := fit-coxCure/$(iter).RData
fit_rsf := fit-rsf/$(iter).RData
fit_deepSurv := fit-deepSurv/$(iter).csv
sum_coxCure := sum_rdata/sum_coxCure.RData
sum_rsf := sum_rdata/sum_rsf.RData
sum_deepSurv := sum_rdata/sum_deepSurv.RData


## simulating all models
.PHONY: all
all:
	@printf "[$$(date)]: Simulation started. Be patient.\n" | tee nohup.out
	@nohup $(MAKE) summary &>> nohup.out &
	@printf "Please see nohup.out and other log files for progress.\n"

.PHONY: data
data: $(simu_data)

$(simu_data): simu-data.R simu-fun.R
	@./$<
	@printf "[$$(date)]: All simulation data were generated.\n"

.PHONY: coxCure
coxCure: $(fit_coxCure)

$(fit_coxCure): fit-coxCure.R fit-coxCure.sh $(simu_data)
	@bash fit-coxCure.sh &> fit-coxCure.log
	@printf "[$$(date)]: Fitted all Cox cure models.\n"

.PHONY: rsf
rsf: $(fit_rsf)

$(fit_rsf): fit-rsf.R fit-rsf.sh $(simu_data)
	@bash fit-rsf.sh &> fit-rsf.log
	@printf "[$$(date)]: Fitted all RSF models.\n"

.PHONY: deepSurv
deepSurv: $(fit_deepSurv)

$(fit_deepSurv): fit-deepSurv.py fit-deepSurv.sh $(simu_data)
	@bash fit-deepSurv.sh &> fit-deepSurv.log
	@printf "[$$(date)]: Fitted all DeepSurv models.\n"

.PHONY: summary
summary: $(sum_coxCure) $(sum_rsf) $(sum_deepSurv)
	@printf "[$$(date)]: Summaized all the results.\n"

$(sum_coxCure): sum-coxCure.R $(fit_coxCure)
	@Rscript --vanilla $<

$(sum_rsf): sum-rsf.R $(fit_rsf)
	@Rscript --vanilla $<

$(sum_deepSurv): sum-deepSurv.R $(fit_deepSurv)
	@Rscript --vanilla $<

.PHONY: Tensorboard
Tensorboard:
	tensorboard --logdir deepSurv_logs/tensorboard/ &> /dev/null

.PHONY: clean
clean:
	@rm -rf *~ *.log nohup.out
	@printf "[$$(date)]: Cleaned all logs and temp files.\n"

.PHONY: cleanAll
cleanAll: clean
	@rm -rf deepSurv_logs/ simu-data/ fit-coxCure/ fit-rsf/ fit-deepSurv/ sum_rdata/
	@printf "[$$(date)]: Cleaned simulation results.\n"
