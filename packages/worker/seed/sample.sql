-- 自動生成。手で編集しないこと。
-- 生成: node scripts/gen-seed.mjs > packages/worker/seed/sample.sql
--
-- **これは合成データで、本物の市場データではない。** 画面の見た目と
-- パイプラインの出力形を確認するためのもの。銘柄名に（サンプル）が付き、
-- 画面上部にも警告が出る。

DELETE FROM scores_daily;
DELETE FROM signals_daily;
DELETE FROM indicators_daily;
DELETE FROM prices_daily;
DELETE FROM symbols;
DELETE FROM job_runs;

INSERT INTO symbols (symbol_id, market, code, name, sector33, currency, updated_at) VALUES ('JP.13010', 'JP', '13010', '極洋（サンプル）', '水産・農林業', 'JPY', '2026-08-27');
INSERT INTO symbols (symbol_id, market, code, name, sector33, currency, updated_at) VALUES ('JP.67580', 'JP', '67580', 'ソニー（サンプル）', '電気機器', 'JPY', '2026-08-27');
INSERT INTO symbols (symbol_id, market, code, name, sector33, currency, updated_at) VALUES ('JP.72030', 'JP', '72030', 'トヨタ（サンプル）', '輸送用機器', 'JPY', '2026-08-27');
INSERT INTO symbols (symbol_id, market, code, name, sector33, currency, updated_at) VALUES ('JP.99840', 'JP', '99840', 'ＳＢ（サンプル）', '情報・通信業', 'JPY', '2026-08-27');
INSERT INTO symbols (symbol_id, market, code, name, sector33, currency, updated_at) VALUES ('JP.80580', 'JP', '80580', '三菱商事（サンプル）', '卸売業', 'JPY', '2026-08-27');

INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.13010','2025-08-29',4231.7,4248.4,4211.4,4218.3,908472,1.0),
  ('JP.13010','2025-09-01',4176.4,4210.6,4180.8,4186.4,1014568,1.0),
  ('JP.13010','2025-09-02',4196.9,4241.4,4193.3,4219.6,1077559,1.0),
  ('JP.13010','2025-09-03',4191.1,4221.8,4192,4214.1,944603,1.0),
  ('JP.13010','2025-09-04',4227.8,4243,4202.3,4223.9,971162,1.0),
  ('JP.13010','2025-09-05',4291.9,4291.1,4231.4,4274.3,1154010,1.0),
  ('JP.13010','2025-09-08',4253.4,4269.7,4243.7,4255.2,1202752,1.0),
  ('JP.13010','2025-09-09',4274.8,4290.1,4237.3,4260.5,1217383,1.0),
  ('JP.13010','2025-09-10',4298,4343.2,4278.4,4299.3,1162355,1.0),
  ('JP.13010','2025-09-11',4296.6,4325.5,4276.9,4294.1,1186269,1.0),
  ('JP.13010','2025-09-12',4331.3,4366.4,4310.7,4327.6,1160159,1.0),
  ('JP.13010','2025-09-15',4333.3,4342,4305.8,4314.5,1065309,1.0),
  ('JP.13010','2025-09-16',4338.5,4347.4,4285.2,4331.4,1187199,1.0),
  ('JP.13010','2025-09-17',4363.1,4408.6,4315.2,4358.5,1106679,1.0),
  ('JP.13010','2025-09-18',4368,4356.8,4316.1,4350.6,986223,1.0),
  ('JP.13010','2025-09-19',4329.7,4363.8,4343.7,4354.6,1039317,1.0),
  ('JP.13010','2025-09-22',4382.7,4413.7,4368.9,4371.1,919900,1.0),
  ('JP.13010','2025-09-23',4398.2,4415.9,4368.5,4383.8,986390,1.0),
  ('JP.13010','2025-09-24',4344.5,4390.1,4334.7,4364.3,956520,1.0),
  ('JP.13010','2025-09-25',4391.7,4419.6,4321.8,4372.6,894225,1.0),
  ('JP.13010','2025-09-26',4403.1,4420.8,4352.4,4389.3,777962,1.0),
  ('JP.13010','2025-09-29',4388.6,4424.4,4388.6,4403.6,760980,1.0),
  ('JP.13010','2025-09-30',4431.4,4466.1,4388.4,4414.6,863377,1.0),
  ('JP.13010','2025-10-01',4391.4,4425.8,4350.8,4389.5,676211,1.0),
  ('JP.13010','2025-10-02',4400.1,4446.2,4390.4,4396.1,627210,1.0),
  ('JP.13010','2025-10-03',4431.7,4487,4423,4437.9,625678,1.0),
  ('JP.13010','2025-10-06',4437.8,4454.8,4380.6,4432,604488,1.0),
  ('JP.13010','2025-10-07',4460.8,4473.1,4437,4454.1,641694,1.0),
  ('JP.13010','2025-10-08',4436.6,4463,4388,4424.9,692089,1.0),
  ('JP.13010','2025-10-09',4412.5,4483.8,4427.9,4433.2,750594,1.0),
  ('JP.13010','2025-10-10',4465.9,4479.2,4416.3,4447.3,684575,1.0),
  ('JP.13010','2025-10-13',4423.5,4464.6,4418.2,4440.7,748004,1.0),
  ('JP.13010','2025-10-14',4457.7,4498.3,4405.7,4447.5,599596,1.0),
  ('JP.13010','2025-10-15',4471.7,4503.5,4439.6,4452.5,681944,1.0),
  ('JP.13010','2025-10-16',4412.2,4469.3,4428.9,4436.9,683345,1.0),
  ('JP.13010','2025-10-17',4436.1,4451.2,4427.4,4435.3,705993,1.0),
  ('JP.13010','2025-10-20',4471.5,4469.7,4430.3,4450.8,733568,1.0),
  ('JP.13010','2025-10-21',4434.3,4467,4435.1,4446.6,842285,1.0),
  ('JP.13010','2025-10-22',4481.7,4477.2,4452.9,4462.4,988747,1.0),
  ('JP.13010','2025-10-23',4433.1,4475.9,4422,4444.3,1029359,1.0),
  ('JP.13010','2025-10-24',4467.4,4491.7,4441.8,4465.4,919720,1.0),
  ('JP.13010','2025-10-27',4482,4476.1,4454.5,4465.3,985584,1.0),
  ('JP.13010','2025-10-28',4440.2,4460.4,4409.8,4421.8,1136755,1.0),
  ('JP.13010','2025-10-29',4464,4456,4430,4440.9,1157297,1.0),
  ('JP.13010','2025-10-30',4454.1,4500.6,4438.1,4448.7,1103402,1.0),
  ('JP.13010','2025-10-31',4393,4448.5,4383.7,4415.3,1104616,1.0),
  ('JP.13010','2025-11-03',4405.4,4416.5,4356.6,4406.2,1140817,1.0),
  ('JP.13010','2025-11-04',4411,4461.2,4373.4,4415.7,1169455,1.0),
  ('JP.13010','2025-11-05',4384.8,4395.9,4363.3,4392.4,1125234,1.0),
  ('JP.13010','2025-11-06',4422.7,4405.4,4380.9,4396.4,1132247,1.0),
  ('JP.13010','2025-11-07',4396.7,4400.3,4361.1,4397.8,1039272,1.0),
  ('JP.13010','2025-11-10',4440.9,4426.3,4385.6,4414.8,1058596,1.0),
  ('JP.13010','2025-11-11',4364.2,4403.3,4352.4,4380.8,1147389,1.0),
  ('JP.13010','2025-11-12',4373.8,4419.1,4356.7,4397.5,1027181,1.0),
  ('JP.13010','2025-11-13',4377,4401.6,4368.3,4380.6,939432,1.0),
  ('JP.13010','2025-11-14',4351.3,4390.9,4312.8,4355.8,978114,1.0),
  ('JP.13010','2025-11-17',4352.4,4386,4319,4338.6,936496,1.0),
  ('JP.13010','2025-11-18',4346.1,4365,4342.5,4359,889139,1.0),
  ('JP.13010','2025-11-19',4308.3,4374.1,4294.1,4329.1,892578,1.0),
  ('JP.13010','2025-11-20',4343.7,4381.5,4333.4,4336.8,738095,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.13010','2025-11-21',4339,4364.6,4297.5,4330.4,666360,1.0),
  ('JP.13010','2025-11-24',4312.3,4345.5,4264.7,4313.5,806342,1.0),
  ('JP.13010','2025-11-25',4292.9,4330,4274.4,4314.7,792353,1.0),
  ('JP.13010','2025-11-26',4277.2,4326.6,4285.9,4298.2,681987,1.0),
  ('JP.13010','2025-11-27',4297,4367.5,4293.1,4318.8,762084,1.0),
  ('JP.13010','2025-11-28',4272.5,4308.3,4233.4,4278.5,596142,1.0),
  ('JP.13010','2025-12-01',4273.2,4301.1,4250.4,4272.2,746512,1.0),
  ('JP.13010','2025-12-02',4260.4,4310.3,4275.2,4277.4,732669,1.0),
  ('JP.13010','2025-12-03',4249.7,4287.4,4255.5,4266.3,762892,1.0),
  ('JP.13010','2025-12-04',4216.9,4266.9,4207.8,4240.5,654363,1.0),
  ('JP.13010','2025-12-05',4229.7,4280.8,4214.5,4243.5,625440,1.0),
  ('JP.13010','2025-12-08',4230.6,4288.8,4213.5,4246.2,648871,1.0),
  ('JP.13010','2025-12-09',4211.3,4260.9,4214.5,4221.1,831772,1.0),
  ('JP.13010','2025-12-10',4257.6,4272.6,4228.8,4233.4,778250,1.0),
  ('JP.13010','2025-12-11',4204.6,4225.2,4204.2,4214.8,938855,1.0),
  ('JP.13010','2025-12-12',4179.8,4230.2,4148.3,4190.5,979513,1.0),
  ('JP.13010','2025-12-15',4165.6,4191.8,4138.6,4188.2,985457,1.0),
  ('JP.13010','2025-12-16',4160.3,4207.6,4120.8,4169.3,872275,1.0),
  ('JP.13010','2025-12-17',4164.2,4217.9,4179.5,4186.3,1035458,1.0),
  ('JP.13010','2025-12-18',4167.9,4186,4104.3,4150.1,1046188,1.0),
  ('JP.13010','2025-12-19',4171.5,4199.3,4140.7,4155,1160308,1.0),
  ('JP.13010','2025-12-22',4139,4192.2,4114.6,4156,1087731,1.0),
  ('JP.13010','2025-12-23',4147.9,4205.8,4148.5,4170.5,1061902,1.0),
  ('JP.13010','2025-12-24',4149.9,4189.5,4122,4151.3,1125693,1.0),
  ('JP.13010','2025-12-25',4154.7,4175.3,4101.4,4149.7,1071740,1.0),
  ('JP.13010','2025-12-26',4119.2,4139.9,4109.6,4128.1,1189682,1.0),
  ('JP.13010','2025-12-29',4117.8,4137.9,4124.2,4129.4,1160866,1.0),
  ('JP.13010','2025-12-30',4127.8,4155.7,4089.8,4126.4,1048899,1.0),
  ('JP.13010','2025-12-31',4137.2,4154.3,4087.2,4122.7,1070314,1.0),
  ('JP.13010','2026-01-01',4093.2,4117.8,4076.1,4103.5,1191603,1.0),
  ('JP.13010','2026-01-02',4144.8,4152.5,4117.4,4124.6,1036078,1.0),
  ('JP.13010','2026-01-05',4148,4130.7,4081.5,4129.8,1081697,1.0),
  ('JP.13010','2026-01-06',4111.2,4109,4079.4,4107.1,1048467,1.0),
  ('JP.13010','2026-01-07',4138,4155.3,4120.8,4121.7,950201,1.0),
  ('JP.13010','2026-01-08',4106.3,4140.8,4108.1,4112.2,865656,1.0),
  ('JP.13010','2026-01-09',4104,4148.8,4109.4,4114.6,808502,1.0),
  ('JP.13010','2026-01-12',4104.2,4151.5,4088.7,4122.2,907672,1.0),
  ('JP.13010','2026-01-13',4095.5,4136.7,4056.3,4090.8,869724,1.0),
  ('JP.13010','2026-01-14',4070.6,4091.2,4046.7,4084.4,802643,1.0),
  ('JP.13010','2026-01-15',4112.8,4110.9,4105.1,4108.6,796811,1.0),
  ('JP.13010','2026-01-16',4092.8,4118.1,4075.6,4099.8,754168,1.0),
  ('JP.13010','2026-01-19',4151.3,4143.9,4102.2,4136.4,723429,1.0),
  ('JP.13010','2026-01-20',4105.2,4136.3,4074.1,4115.4,559843,1.0),
  ('JP.13010','2026-01-21',4133.9,4132.9,4079.7,4128.3,679197,1.0),
  ('JP.13010','2026-01-22',4121.3,4164.7,4102.1,4127.7,648633,1.0),
  ('JP.13010','2026-01-23',4153.8,4160.1,4111.7,4142.5,656348,1.0),
  ('JP.13010','2026-01-26',4126.8,4158.9,4120.4,4132.9,631540,1.0),
  ('JP.13010','2026-01-27',4138.2,4179.9,4129.2,4141.2,743409,1.0),
  ('JP.13010','2026-01-28',4168.4,4193.1,4130.3,4157.4,788275,1.0),
  ('JP.13010','2026-01-29',4167.8,4176.8,4148.2,4161.6,685227,1.0),
  ('JP.13010','2026-01-30',4177.5,4180.1,4114.9,4154.9,755039,1.0),
  ('JP.13010','2026-02-02',4151,4194,4097.8,4145.7,770242,1.0),
  ('JP.13010','2026-02-03',4124.9,4193.8,4146.4,4149.7,847365,1.0),
  ('JP.13010','2026-02-04',4146.7,4201.8,4153.3,4157.5,857778,1.0),
  ('JP.13010','2026-02-05',4203.9,4232.3,4162.2,4184.7,860013,1.0),
  ('JP.13010','2026-02-06',4181.2,4213.3,4194.9,4200,902827,1.0),
  ('JP.13010','2026-02-09',4181.8,4228.2,4179,4184.6,1045385,1.0),
  ('JP.13010','2026-02-10',4220.3,4250.4,4187.1,4227.3,1075812,1.0),
  ('JP.13010','2026-02-11',4214.8,4243.5,4181.9,4227.3,995605,1.0),
  ('JP.13010','2026-02-12',4249,4253.3,4240.9,4242.6,1172651,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.13010','2026-02-13',4230,4271.4,4180,4222.5,1153550,1.0),
  ('JP.13010','2026-02-16',4232.4,4285.3,4226.7,4245.9,1228617,1.0),
  ('JP.13010','2026-02-17',4251.5,4286.4,4205.4,4248,1167407,1.0),
  ('JP.13010','2026-02-18',4284.3,4300.8,4239.1,4266.8,1150465,1.0),
  ('JP.13010','2026-02-19',4278,4299.8,4250.1,4278.8,1094161,1.0),
  ('JP.13010','2026-02-20',4277.6,4281.4,4255,4256.8,1127623,1.0),
  ('JP.13010','2026-02-23',4290.2,4313.1,4277.5,4310.8,1062324,1.0),
  ('JP.13010','2026-02-24',4306.7,4329.3,4294.5,4313.4,1037355,1.0),
  ('JP.13010','2026-02-25',4339.6,4351.2,4317.8,4320.8,1035706,1.0),
  ('JP.13010','2026-02-26',4314.8,4333.2,4277,4324.1,983284,1.0),
  ('JP.13010','2026-02-27',4314.7,4388.8,4310.1,4339.4,890562,1.0),
  ('JP.13010','2026-03-02',4356.4,4395.6,4321.8,4365,963887,1.0),
  ('JP.13010','2026-03-03',4391.6,4420.4,4350.7,4371.1,940550,1.0),
  ('JP.13010','2026-03-04',4366.7,4416.6,4352.7,4389,820188,1.0),
  ('JP.13010','2026-03-05',4379.2,4375.5,4336.3,4368.7,830133,1.0),
  ('JP.13010','2026-03-06',4383.8,4419.7,4378.6,4388.4,722220,1.0),
  ('JP.13010','2026-03-09',4411.5,4432.8,4379.8,4405.1,779713,1.0),
  ('JP.13010','2026-03-10',4425.8,4436.3,4410.7,4433.3,684528,1.0),
  ('JP.13010','2026-03-11',4385.1,4416.8,4359.3,4400.8,617629,1.0),
  ('JP.13010','2026-03-12',4425.1,4467.3,4392.3,4430.9,614466,1.0),
  ('JP.13010','2026-03-13',4444.2,4470.7,4437,4449.7,687408,1.0),
  ('JP.13010','2026-03-16',4468.6,4487.5,4455.6,4460.3,555800,1.0),
  ('JP.13010','2026-03-17',4483.4,4480.5,4447.5,4457.7,686061,1.0),
  ('JP.13010','2026-03-18',4469,4529.4,4449.6,4488.1,756761,1.0),
  ('JP.13010','2026-03-19',4497.2,4512.7,4494.6,4496.4,583137,1.0),
  ('JP.13010','2026-03-20',4519.2,4565.4,4477.6,4519,728523,1.0),
  ('JP.13010','2026-03-23',4507.2,4523.7,4505.2,4523,703219,1.0),
  ('JP.13010','2026-03-24',4543.1,4562.8,4488.1,4528.7,829810,1.0),
  ('JP.13010','2026-03-25',4521.4,4532.1,4474.4,4510.6,839065,1.0),
  ('JP.13010','2026-03-26',4503.3,4535.6,4483.3,4510.2,878337,1.0),
  ('JP.13010','2026-03-27',4523.6,4585.2,4504.6,4537.2,811234,1.0),
  ('JP.13010','2026-03-30',4551.5,4609.2,4560.4,4568.8,912583,1.0),
  ('JP.13010','2026-03-31',4584,4624.6,4561.9,4577.5,1015151,1.0),
  ('JP.13010','2026-04-01',4575.4,4631.9,4569.3,4578.9,1070548,1.0),
  ('JP.13010','2026-04-02',4555.8,4618.5,4531.6,4567.3,1110840,1.0),
  ('JP.13010','2026-04-03',4554.8,4570.3,4530.3,4552.2,1078101,1.0),
  ('JP.13010','2026-04-06',4581.8,4625.1,4543,4586,1126315,1.0),
  ('JP.13010','2026-04-07',4613.9,4635.8,4543.8,4597.1,1210792,1.0),
  ('JP.13010','2026-04-08',4557.6,4627.7,4566.4,4583.9,1175543,1.0),
  ('JP.13010','2026-04-09',4593.4,4653.5,4568.8,4610.1,1072110,1.0),
  ('JP.13010','2026-04-10',4548.5,4586.1,4534.6,4572.9,1148307,1.0),
  ('JP.13010','2026-04-13',4575.2,4576.8,4563.7,4575.1,1080602,1.0),
  ('JP.13010','2026-04-14',4569.6,4617.3,4589.3,4597,1224835,1.0),
  ('JP.13010','2026-04-15',4648.6,4651.9,4593,4622.7,1040508,1.0),
  ('JP.13010','2026-04-16',4615.7,4639.9,4564.6,4600.1,1115180,1.0),
  ('JP.13010','2026-04-17',4615.3,4669.1,4588.2,4629.9,1148144,1.0),
  ('JP.13010','2026-04-20',4582,4645,4566.8,4608.7,1034473,1.0),
  ('JP.13010','2026-04-21',4574.9,4593.8,4542.6,4592,921653,1.0),
  ('JP.13010','2026-04-22',4594.2,4630.9,4568.9,4608.6,1012915,1.0),
  ('JP.13010','2026-04-23',4628.2,4617,4604.1,4612.9,997437,1.0),
  ('JP.13010','2026-04-24',4609.2,4628.6,4567,4605.3,916172,1.0),
  ('JP.13010','2026-04-27',4626.5,4655.1,4578.2,4619.6,775109,1.0),
  ('JP.13010','2026-04-28',4627.6,4659.9,4576.3,4605,730191,1.0),
  ('JP.13010','2026-04-29',4614.2,4670.9,4601.7,4617.5,676587,1.0),
  ('JP.13010','2026-04-30',4568.1,4603,4560.8,4575,756826,1.0),
  ('JP.13010','2026-05-01',4596,4625.8,4594,4613.2,776620,1.0),
  ('JP.13010','2026-05-04',4612.2,4596.2,4558.3,4594.7,585674,1.0),
  ('JP.13010','2026-05-05',4557.2,4603.1,4576.7,4581.2,723889,1.0),
  ('JP.13010','2026-05-06',4595,4649.6,4563.8,4599.1,565472,1.0),
  ('JP.13010','2026-05-07',4540.8,4612.2,4512.8,4558.3,666614,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.13010','2026-05-08',4612.7,4640.1,4540.2,4590.8,607994,1.0),
  ('JP.13010','2026-05-11',4575.5,4609.1,4541,4580.9,686550,1.0),
  ('JP.13010','2026-05-12',4546.9,4622.5,4549.9,4572.2,630987,1.0),
  ('JP.13010','2026-05-13',4540.5,4590.9,4521.6,4545.1,693142,1.0),
  ('JP.13010','2026-05-14',4529,4563.9,4517.9,4540.7,796856,1.0),
  ('JP.13010','2026-05-15',4582.7,4582.1,4543.9,4563.4,797676,1.0),
  ('JP.13010','2026-05-18',4558.6,4581.4,4482.2,4534.1,843000,1.0),
  ('JP.13010','2026-05-19',4502.4,4518.3,4486.9,4504.5,938264,1.0),
  ('JP.13010','2026-05-20',4526.2,4540.5,4500.2,4525.7,840536,1.0),
  ('JP.13010','2026-05-21',4557.9,4550.3,4528.8,4531.7,922704,1.0),
  ('JP.13010','2026-05-22',4478.3,4511.9,4451.4,4487.1,972948,1.0),
  ('JP.13010','2026-05-25',4502.1,4508,4463.4,4483.1,960356,1.0),
  ('JP.13010','2026-05-26',4485.3,4523.2,4442.6,4495.6,1007645,1.0),
  ('JP.13010','2026-05-27',4440.8,4501.2,4413.5,4457.6,1128568,1.0),
  ('JP.13010','2026-05-28',4447.9,4482.9,4412.2,4454.1,1153913,1.0),
  ('JP.13010','2026-05-29',4451.9,4496.5,4473.9,4477.8,1126394,1.0),
  ('JP.13010','2026-06-01',4478,4484.3,4442.6,4473.4,1172777,1.0),
  ('JP.13010','2026-06-02',4464.9,4495.8,4424.2,4463.9,1070888,1.0),
  ('JP.13010','2026-06-03',4446.9,4477.9,4418.4,4434.5,1240471,1.0),
  ('JP.13010','2026-06-04',4419.5,4460.7,4397.6,4431.6,1051635,1.0),
  ('JP.13010','2026-06-05',4426.3,4458.7,4374.8,4415.3,1179912,1.0),
  ('JP.13010','2026-06-08',4417.2,4453.3,4391.8,4417.8,1039864,1.0),
  ('JP.13010','2026-06-09',4403.9,4382,4364.3,4380.7,1176349,1.0),
  ('JP.13010','2026-06-10',4376.4,4422.5,4349.5,4396.8,1011987,1.0),
  ('JP.13010','2026-06-11',4367,4427.9,4338.3,4386.2,996746,1.0),
  ('JP.13010','2026-06-12',4356.2,4394.1,4311.7,4363.1,956254,1.0),
  ('JP.13010','2026-06-15',4399.2,4404,4348.7,4383.7,949830,1.0),
  ('JP.13010','2026-06-16',4391.8,4403.8,4359.3,4381.8,847827,1.0),
  ('JP.13010','2026-06-17',4341.4,4390.4,4320.4,4359.6,967774,1.0),
  ('JP.13010','2026-06-18',4343.8,4398.6,4312.8,4353.4,864550,1.0),
  ('JP.13010','2026-06-19',4336.5,4379.5,4310.3,4357.2,773462,1.0),
  ('JP.13010','2026-06-22',4297.7,4350.1,4300.5,4315.8,735413,1.0),
  ('JP.13010','2026-06-23',4308.8,4331.4,4291.4,4328.9,731914,1.0),
  ('JP.13010','2026-06-24',4323.4,4364.2,4305.5,4330.4,728785,1.0),
  ('JP.13010','2026-06-25',4282.7,4317.8,4255,4292,583077,1.0),
  ('JP.13010','2026-06-26',4318,4362.9,4325.2,4329.9,660333,1.0),
  ('JP.13010','2026-06-29',4316.7,4362.9,4292.5,4315.1,628374,1.0),
  ('JP.13010','2026-06-30',4277.7,4324.7,4282.8,4300.9,593704,1.0),
  ('JP.13010','2026-07-01',4273.2,4324.1,4265.3,4293.9,607643,1.0),
  ('JP.13010','2026-07-02',4302,4319.4,4288,4299.8,682986,1.0),
  ('JP.13010','2026-07-03',4298,4319.9,4230.1,4278,668922,1.0),
  ('JP.13010','2026-07-06',4256.5,4307.1,4228.3,4269.3,627263,1.0),
  ('JP.13010','2026-07-07',4300.4,4301.1,4243.5,4291.9,813334,1.0),
  ('JP.13010','2026-07-08',4294.2,4319.2,4248.3,4286.3,736585,1.0),
  ('JP.13010','2026-07-09',4222.8,4298.4,4215.6,4247.5,803785,1.0),
  ('JP.13010','2026-07-10',4258.7,4278.4,4231.5,4257.2,808114,1.0),
  ('JP.13010','2026-07-13',4273.9,4289.1,4232.3,4270.1,871631,1.0),
  ('JP.13010','2026-07-14',4264.7,4327.7,4241.1,4290.1,943358,1.0),
  ('JP.13010','2026-07-15',4246.4,4290.4,4247.4,4251.3,1052519,1.0),
  ('JP.13010','2026-07-16',4218.7,4290.3,4228.5,4243.4,1064926,1.0),
  ('JP.13010','2026-07-17',4264.6,4299.4,4251.1,4276.8,1143709,1.0),
  ('JP.13010','2026-07-20',4286.4,4312.4,4231.7,4274.8,1076582,1.0),
  ('JP.13010','2026-07-21',4298.9,4300.7,4232.9,4283.3,1112878,1.0),
  ('JP.13010','2026-07-22',4287,4290.5,4275.5,4280.7,1116017,1.0),
  ('JP.13010','2026-07-23',4283.5,4312.7,4263.6,4285.8,1215153,1.0),
  ('JP.13010','2026-07-24',4253,4302.1,4216.2,4262.9,1238244,1.0),
  ('JP.13010','2026-07-27',4239,4287.7,4263.7,4264.5,1103454,1.0),
  ('JP.13010','2026-07-28',4279.5,4328.9,4266.9,4296,1101340,1.0),
  ('JP.13010','2026-07-29',4287.3,4307,4256.8,4296.5,1159634,1.0),
  ('JP.13010','2026-07-30',4289.8,4291.1,4226.1,4272.7,1067862,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.13010','2026-07-31',4319.4,4324.3,4294.3,4316.4,1142884,1.0),
  ('JP.13010','2026-08-03',4318.2,4316.1,4301.6,4306.6,1147230,1.0),
  ('JP.13010','2026-08-04',4343.5,4323.1,4289.2,4318.5,959894,1.0),
  ('JP.13010','2026-08-05',4326.1,4339,4291.8,4329.2,1049132,1.0),
  ('JP.13010','2026-08-06',4342.2,4340.2,4291.1,4317.6,920901,1.0),
  ('JP.13010','2026-08-07',4311.9,4376.2,4308.9,4336.1,858074,1.0),
  ('JP.13010','2026-08-10',4362.8,4389.4,4344.7,4351.7,769384,1.0),
  ('JP.13010','2026-08-11',4340.1,4380,4330.7,4343.8,737079,1.0),
  ('JP.13010','2026-08-12',4349.1,4386.1,4328.6,4347.6,873421,1.0),
  ('JP.13010','2026-08-13',4365.7,4431.6,4349.7,4381.1,786735,1.0),
  ('JP.13010','2026-08-14',4408.7,4404.6,4346.4,4384.5,755985,1.0),
  ('JP.13010','2026-08-17',4357.8,4389.6,4362.6,4371.5,786780,1.0),
  ('JP.13010','2026-08-18',4423,4433.1,4378.9,4409,632264,1.0),
  ('JP.13010','2026-08-19',4409.5,4423,4342.6,4394.2,593685,1.0),
  ('JP.13010','2026-08-20',4370.7,4426.5,4388.7,4394.6,727019,1.0),
  ('JP.13010','2026-08-21',4391.5,4439.5,4369.6,4409.9,721814,1.0),
  ('JP.13010','2026-08-24',4444.5,4502,4415.8,4451.8,676355,1.0),
  ('JP.13010','2026-08-25',4475.2,4475.1,4432.4,4459.1,660103,1.0),
  ('JP.13010','2026-08-26',4434,4481,4442.2,4452.5,788814,1.0),
  ('JP.13010','2026-08-27',4475.1,4508.3,4461.1,4478.5,633414,1.0);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-03',29.92,-45.99,-45.91,-0.08,4297.54,4363.35,4496.65,4368.44,62.97,810289.7,0.8255,-0.031096,-0.064489,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-03','golden_cross',0,'{"met":[],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-03','exit',3,'{"met":["macd_dead_cross","below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-03','v1-technical',13,0,2,0,0,4,4,NULL,NULL,'AVOID',4278,4152.07,4466.9,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-06',28.8,-46.51,-46.03,-0.48,4288.38,4355.18,4493.26,4367.77,64.1,789659.65,0.7943,-0.033614,-0.06684,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-06','golden_cross',0,'{"met":[],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-06','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-06','v1-technical',9,0,2,0,0,1,4,NULL,NULL,'AVOID',4269.3,4141.1,4461.59,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-07',35.57,-44.59,-45.74,1.15,4286.58,4348.3,4490.11,4367.16,63.63,771508.9,1.0542,-0.020271,-0.066369,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-07','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-07','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-07','v1-technical',30,0,3,13,0,4,4,NULL,NULL,'AVOID',4291.9,4164.63,4482.8,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-08',34.69,-43.03,-45.2,2.17,4285.06,4342.38,4487.11,4366.64,64.15,757738.8,0.9721,-0.025132,-0.072771,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-08','golden_cross',2,'{"met":["macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-08','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-08','v1-technical',30,0,3,13,0,4,4,NULL,NULL,'AVOID',4286.3,4157.99,4478.76,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-09',29.28,-44.41,-45.04,0.64,4274.6,4335.01,4483.61,4365.9,65.48,748090.75,1.0744,-0.031622,-0.076651,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-09','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-09','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-09','v1-technical',25,0,2,10,0,4,4,NULL,NULL,'AVOID',4247.5,4116.53,4443.95,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-10',32.13,-44.2,-44.87,0.67,4270.44,4328.69,4479.88,4364.99,64.16,740683.75,1.091,-0.024272,-0.080498,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-10','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-10','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-10','v1-technical',30,0,3,13,0,4,4,NULL,NULL,'AVOID',4257.2,4128.89,4449.67,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-13',35.83,-42.52,-44.4,1.89,4270.6,4322.78,4475.9,4364.18,63.63,736773.8,1.183,-0.025914,-0.07347,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-13','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-13','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-13','v1-technical',33,0,3,13,2,4,4,NULL,NULL,'AVOID',4270.1,4142.84,4461,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-14',41.19,-39.11,-43.34,4.23,4270.24,4319.16,4472.06,4363.36,65.27,741550.35,1.2721,-0.020927,-0.065745,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-14','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-14','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-14','v1-technical',38,0,5,13,0,8,4,NULL,NULL,'AVOID',4290.1,4159.56,4485.92,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-15',35.07,-39.09,-42.49,3.4,4263.24,4313.34,4467.7,4362.5,63.68,745787.6,1.4113,-0.024842,-0.077529,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-15','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-15','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-15','v1-technical',31,0,3,10,0,8,4,NULL,NULL,'AVOID',4251.3,4123.94,4442.34,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-16',33.97,-39.26,-41.85,2.58,4262.42,4307.62,4463.38,4361.55,63.55,755806.4,1.409,-0.025268,-0.080101,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-16','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-16','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-16','v1-technical',31,0,3,10,0,8,4,NULL,NULL,'AVOID',4243.4,4116.31,4434.04,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-17',42.26,-36.29,-40.74,4.45,4266.34,4304.17,4459.71,4360.7,63.01,774318.75,1.4771,-0.018452,-0.071331,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-17','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-17','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-17','v1-technical',40,0,5,13,2,8,4,NULL,NULL,'AVOID',4276.8,4150.78,4465.82,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-20',41.92,-33.7,-39.33,5.63,4267.28,4299.82,4455.56,4359.87,64.27,791377.2,1.3604,-0.0095,-0.074638,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-20','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-20','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-20','v1-technical',40,0,5,13,2,8,4,NULL,NULL,'AVOID',4274.8,4146.26,4467.62,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-21',43.98,-30.61,-37.59,6.97,4265.92,4295.88,4451.37,4359.04,64.52,810425.4,1.3732,-0.010534,-0.069859,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-21','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-21','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-21','v1-technical',38,0,5,13,0,8,4,NULL,NULL,'AVOID',4283.3,4154.25,4476.87,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-22',43.47,-28.05,-35.68,7.63,4271.8,4292.72,4447.33,4358.19,60.99,829787,1.3449,-0.011477,-0.07294,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-22','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-22','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-22','v1-technical',40,0,5,13,2,8,4,NULL,NULL,'AVOID',4280.7,4158.73,4463.66,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-23',44.81,-25.32,-33.61,8.29,4280.28,4290.02,4443.01,4357.43,60.14,861390.8,1.4107,-0.001445,-0.063213,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-23','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-23','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-23','v1-technical',40,0,5,13,2,8,4,NULL,NULL,'AVOID',4285.8,4165.53,4466.21,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-24',40.19,-24.71,-31.83,7.11,4277.5,4286.24,4438.87,4356.57,61.98,890286.35,1.3908,-0.015474,-0.075934,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-24','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-24','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-24','v1-technical',34,0,5,10,0,8,4,NULL,NULL,'AVOID',4262.9,4138.94,4448.83,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-27',40.65,-23.83,-30.23,6.4,4275.44,4284.19,4434.73,4355.64,59.32,914040.35,1.2072,-0.011726,-0.071865,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-27','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-27','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-27','v1-technical',34,0,5,10,0,8,4,NULL,NULL,'AVOID',4264.5,4145.86,4442.47,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-28',48.99,-20.36,-28.25,7.9,4277.98,4282.88,4430.72,4354.88,59.68,939422.15,1.1724,-0.001139,-0.062254,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-28','golden_cross',4,'{"met":["close_above_sma25","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-28','exit',1,'{"met":["sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-28','v1-technical',44,5,7,13,2,4,4,NULL,NULL,'AVOID',4296,4240.05,4475.05,3.2);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-29',49.11,-17.36,-26.07,8.71,4281.14,4281.52,4426.37,4354.05,59.01,967021.7,1.1992,0.000606,-0.065795,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-29','golden_cross',4,'{"met":["close_above_sma25","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-29','exit',1,'{"met":["sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-29','v1-technical',48,5,7,13,2,4,7,NULL,NULL,'AVOID',4296.5,4238.7,4473.52,3.063);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-30',43.74,-16.71,-24.2,7.49,4278.52,4280.75,4422,4353.2,59.82,986265.5,1.0827,-0.006303,-0.062655,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-30','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-30','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-30','v1-technical',29,0,5,10,0,4,4,NULL,NULL,'AVOID',4272.7,4153.06,4452.16,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-07-31',53.74,-12.53,-21.87,9.34,4289.22,4280.21,4417.82,4352.45,59.23,1009963.6,1.1316,0.008976,-0.059772,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-31','golden_cross',6,'{"met":["sma5_above_sma25","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":true,"qualified":true}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-07-31','exit',1,'{"met":["sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-07-31','v1-technical',57,5,10,13,7,4,7,NULL,NULL,'AVOID',4316.4,4237.41,4494.1,2.25);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-03',51.53,-9.89,-19.47,9.58,4297.64,4279.87,4413.79,4351.66,56.06,1035961.95,1.1074,0.008737,-0.059879,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-03','golden_cross',6,'{"met":["sma5_above_sma25","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-03','exit',1,'{"met":["sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-03','v1-technical',57,5,10,13,7,4,7,NULL,NULL,'AVOID',4306.6,4237.07,4474.78,2.419);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-04',54,-6.77,-16.93,10.17,4302.14,4280.57,4410.15,4351.14,54.48,1043289.95,0.9201,0.006198,-0.055488,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-04','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-04','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-04','v1-technical',64,10,10,13,7,4,7,NULL,NULL,'BUY_WATCH',4318.5,4237.77,4481.93,2.024);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-05',56.17,-3.38,-14.22,10.84,4308.68,4281.98,4406.42,4350.58,53.96,1058917.3,0.9908,0.010009,-0.047502,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-05','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-05','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-05','v1-technical',64,10,10,13,7,4,7,NULL,NULL,'BUY_WATCH',4329.2,4239.16,4491.07,1.798);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-06',53.24,-1.62,-11.7,10.08,4317.66,4282.7,4402.49,4349.93,53.61,1064773.1,0.8649,0.016504,-0.049133,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-06','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-06','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-06','v1-technical',60,10,10,10,7,4,7,NULL,NULL,'BUY_WATCH',4317.6,4239.87,4478.43,2.069);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-07',57.09,1.25,-9.11,10.37,4321.6,4285.02,4398.9,4349.53,54.59,1067271.1,0.804,0.018533,-0.049809,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-07','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-07','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-07','v1-technical',66,10,10,15,7,4,7,NULL,NULL,'BUY_WATCH',4336.1,4242.17,4499.86,1.743);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-10',60.07,4.74,-6.34,11.08,4330.62,4288.32,4395.32,4349.26,54.5,1062158.75,0.7244,0.01911,-0.040228,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-10','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-10','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-10','v1-technical',66,10,10,15,10,1,7,NULL,NULL,'BUY_WATCH',4351.7,4245.43,4515.19,1.538);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-11',57.88,6.78,-3.72,10.5,4335.68,4290.39,4391.84,4348.9,54.13,1051844.8,0.7007,0.012517,-0.035675,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-11','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-11','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-11','v1-technical',59,10,10,12,7,1,7,NULL,NULL,'WATCH',4343.8,4247.49,4506.18,1.686);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-12',58.66,8.61,-1.25,9.86,4339.36,4292.84,4388.24,4348.67,54.37,1042889.9,0.8375,0.022652,-0.039353,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-12','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-12','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-12','v1-technical',63,10,10,12,7,4,7,NULL,NULL,'BUY_WATCH',4347.6,4249.92,4510.7,1.67);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-13',64.85,12.62,1.52,11.09,4352.06,4298.19,4385.66,4348.6,56.48,1028980.35,0.7646,0.03245,-0.033233,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-13','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-13','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-13','v1-technical',66,10,10,15,10,1,7,NULL,NULL,'BUY_WATCH',4381.1,4255.21,4550.55,1.346);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-14',65.42,15.88,4.39,11.49,4361.74,4303.28,4382.61,4348.53,56.61,1009594.15,0.7488,0.025182,-0.022866,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-14','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-14','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-14','v1-technical',70,15,8,15,10,1,7,NULL,NULL,'BUY_WATCH',4384.5,4260.25,4554.32,1.367);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-17',61.35,17.22,6.96,10.26,4365.7,4307.34,4379.63,4348.32,54.49,995104.05,0.7907,0.022621,-0.024893,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-17','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-17','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-17','v1-technical',63,10,10,12,10,1,7,NULL,NULL,'BUY_WATCH',4371.5,4264.26,4534.97,1.524);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-18',67.61,21.07,9.78,11.29,4378.74,4312.09,4377.34,4348.46,55,971073.35,0.6511,0.029347,-0.019263,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-18','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-18','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-18','v1-technical',70,15,8,15,10,1,7,NULL,NULL,'BUY_WATCH',4409,4268.97,4574,1.178);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-19',63.25,22.66,12.36,10.3,4388.06,4317.81,4374.6,4348.44,56.81,944956.75,0.6283,0.026514,-0.014223,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-19','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-19','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-19','v1-technical',69,15,10,12,10,1,7,NULL,NULL,'BUY_WATCH',4394.2,4274.63,4564.64,1.425);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-20',63.32,23.68,14.62,9.06,4390.76,4323.86,4372.42,4348.51,55.45,920550.05,0.7898,0.025386,-0.013358,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-20','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-20','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-20','v1-technical',69,15,10,12,10,1,7,NULL,NULL,'BUY_WATCH',4394.6,4280.62,4560.96,1.46);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-21',65.95,25.43,16.78,8.65,4395.84,4329.18,4370.01,4348.78,56.49,894728.55,0.8067,0.034484,-0.015164,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-21','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-21','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-21','v1-technical',70,15,8,12,10,4,7,NULL,NULL,'BUY_WATCH',4409.9,4285.89,4579.36,1.366);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-24',71.88,29.86,19.4,10.46,4411.9,4336.26,4368.29,4349.35,59.03,873373.6,0.7744,0.043921,-0.004829,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-24','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-24','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-24','v1-technical',65,15,4,15,10,1,7,NULL,NULL,'BUY_WATCH',4451.8,4292.9,4628.89,1.114);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-25',72.77,33.57,22.23,11.33,4421.92,4343.29,4366.78,4349.85,57.86,851311.75,0.7754,0.037966,-0.001075,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-25','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-25','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-25','v1-technical',65,15,4,15,10,1,7,NULL,NULL,'BUY_WATCH',4459.1,4343.37,4632.69,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-26',70.6,35.56,24.9,10.66,4433.58,4350.16,4365.55,4350.46,56.5,832770.75,0.9472,0.036309,0.004059,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-26','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-26','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-26','v1-technical',69,15,4,12,10,4,10,NULL,NULL,'BUY_WATCH',4452.5,4306.66,4622.01,1.162);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.13010','2026-08-27',73.91,38.8,27.68,11.12,4450.36,4357.87,4364.72,4351.17,56.45,811048.35,0.781,0.048166,0.010583,4629.9,4084.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-27','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.13010','2026-08-27','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.13010','2026-08-27','v1-technical',69,15,4,15,10,1,10,NULL,NULL,'BUY_WATCH',4478.5,4365.6,4647.86,1.5);

INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.67580','2025-08-29',3216.4,3230.9,3198.8,3214.9,885895,1.0),
  ('JP.67580','2025-09-01',3222.9,3252.8,3204.9,3225.2,975900,1.0),
  ('JP.67580','2025-09-02',3219.4,3259.6,3205.3,3225.4,1045690,1.0),
  ('JP.67580','2025-09-03',3234.9,3251.1,3195.7,3234.3,1052843,1.0),
  ('JP.67580','2025-09-04',3265.9,3263.3,3237.1,3258.5,1143663,1.0),
  ('JP.67580','2025-09-05',3248.3,3285.3,3224.8,3263.9,1145326,1.0),
  ('JP.67580','2025-09-08',3255.1,3296,3263.3,3270.9,1180477,1.0),
  ('JP.67580','2025-09-09',3228.5,3262.3,3241.3,3247.6,1183574,1.0),
  ('JP.67580','2025-09-10',3266.4,3295.6,3276.5,3283.5,1097303,1.0),
  ('JP.67580','2025-09-11',3256.4,3285,3240,3266.7,1087059,1.0),
  ('JP.67580','2025-09-12',3263.7,3278.7,3247.8,3268.4,1156849,1.0),
  ('JP.67580','2025-09-15',3268.2,3287.4,3261.9,3266.2,1132132,1.0),
  ('JP.67580','2025-09-16',3284,3327.2,3295.4,3295.9,1174691,1.0),
  ('JP.67580','2025-09-17',3316.3,3326.1,3298.2,3298.3,1130375,1.0),
  ('JP.67580','2025-09-18',3280.8,3306.2,3252.7,3284.4,1056955,1.0),
  ('JP.67580','2025-09-19',3313.3,3319.3,3282.6,3301.7,1083009,1.0),
  ('JP.67580','2025-09-22',3292,3304,3279.9,3287.4,972479,1.0),
  ('JP.67580','2025-09-23',3283.3,3301.8,3254.3,3290.9,879253,1.0),
  ('JP.67580','2025-09-24',3291.6,3291,3266.8,3288.9,1023771,1.0),
  ('JP.67580','2025-09-25',3282.5,3307.5,3271.8,3282.6,866931,1.0),
  ('JP.67580','2025-09-26',3292.3,3314.6,3277.1,3282.7,893812,1.0),
  ('JP.67580','2025-09-29',3291.3,3329.8,3277.1,3298.8,904316,1.0),
  ('JP.67580','2025-09-30',3285.4,3327.1,3264.2,3297.4,747505,1.0),
  ('JP.67580','2025-10-01',3303.7,3297.7,3289,3292.3,665705,1.0),
  ('JP.67580','2025-10-02',3307.5,3327.4,3274.6,3302.1,669955,1.0),
  ('JP.67580','2025-10-03',3329.7,3330.1,3302.5,3311.3,681986,1.0),
  ('JP.67580','2025-10-06',3323.6,3336,3303.4,3313.6,641122,1.0),
  ('JP.67580','2025-10-07',3277.3,3310,3294,3294,714121,1.0),
  ('JP.67580','2025-10-08',3281.9,3291.3,3280.3,3290.2,690319,1.0),
  ('JP.67580','2025-10-09',3279.6,3306.2,3274.4,3275.5,744295,1.0),
  ('JP.67580','2025-10-10',3310.9,3320.7,3259.8,3293.1,757056,1.0),
  ('JP.67580','2025-10-13',3293.2,3335,3272.3,3297.1,589251,1.0),
  ('JP.67580','2025-10-14',3310.5,3316.7,3279.7,3291,719237,1.0),
  ('JP.67580','2025-10-15',3285.8,3309,3254.7,3281.9,655299,1.0),
  ('JP.67580','2025-10-16',3274.5,3292.9,3249.4,3285.4,748320,1.0),
  ('JP.67580','2025-10-17',3290.8,3303.6,3255.6,3290.9,727310,1.0),
  ('JP.67580','2025-10-20',3289.7,3291.9,3252.3,3270.2,826239,1.0),
  ('JP.67580','2025-10-21',3269.8,3304.4,3272.5,3281.7,877140,1.0),
  ('JP.67580','2025-10-22',3254.5,3259.2,3228.2,3249.5,823058,1.0),
  ('JP.67580','2025-10-23',3263.4,3285.8,3223.2,3248.4,1052877,1.0),
  ('JP.67580','2025-10-24',3251.7,3288.9,3253.5,3254.3,1000183,1.0),
  ('JP.67580','2025-10-27',3223.5,3257.1,3200.9,3239.1,1031550,1.0),
  ('JP.67580','2025-10-28',3222.4,3246.3,3225.8,3239.7,1083739,1.0),
  ('JP.67580','2025-10-29',3263,3261.8,3243.6,3251.8,1047040,1.0),
  ('JP.67580','2025-10-30',3234.5,3281.5,3226,3243.4,1159245,1.0),
  ('JP.67580','2025-10-31',3235.1,3243.9,3187.4,3215.9,1104330,1.0),
  ('JP.67580','2025-11-03',3208.1,3251.2,3189.6,3214.7,1084147,1.0),
  ('JP.67580','2025-11-04',3211.9,3237.3,3192.1,3206.4,1223493,1.0),
  ('JP.67580','2025-11-05',3223.7,3233.9,3201.5,3214.4,1111901,1.0),
  ('JP.67580','2025-11-06',3182.5,3222.4,3187.3,3194.2,1184323,1.0),
  ('JP.67580','2025-11-07',3226.8,3257.2,3216.6,3222.5,1082459,1.0),
  ('JP.67580','2025-11-10',3219.2,3235.2,3198.1,3216.6,1027955,1.0),
  ('JP.67580','2025-11-11',3211.2,3235.4,3208,3210.5,1071691,1.0),
  ('JP.67580','2025-11-12',3177.4,3197.9,3162.8,3195.3,977479,1.0),
  ('JP.67580','2025-11-13',3183.1,3229.8,3161.6,3196.8,919124,1.0),
  ('JP.67580','2025-11-14',3196.7,3184.5,3154.4,3178.7,1028067,1.0),
  ('JP.67580','2025-11-17',3186.4,3201.1,3152.9,3183.2,981715,1.0),
  ('JP.67580','2025-11-18',3194.8,3188.7,3174.7,3185.4,790985,1.0),
  ('JP.67580','2025-11-19',3162.3,3203.1,3168.5,3171.8,903763,1.0),
  ('JP.67580','2025-11-20',3159,3203.5,3161.5,3168.1,717459,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.67580','2025-11-21',3161.1,3196,3131.8,3158.3,762093,1.0),
  ('JP.67580','2025-11-24',3174.5,3163.3,3152.9,3157.1,740316,1.0),
  ('JP.67580','2025-11-25',3157.6,3170.1,3146.9,3169.2,753607,1.0),
  ('JP.67580','2025-11-26',3146,3168.5,3123.8,3155.7,716057,1.0),
  ('JP.67580','2025-11-27',3133.7,3175.5,3127.8,3151.4,651924,1.0),
  ('JP.67580','2025-11-28',3174.1,3187.6,3147.3,3156.4,590058,1.0),
  ('JP.67580','2025-12-01',3127.6,3171.9,3100.9,3138.3,683408,1.0),
  ('JP.67580','2025-12-02',3137.9,3159.4,3111.4,3128.9,605409,1.0),
  ('JP.67580','2025-12-03',3136.9,3160.2,3106.3,3124.4,673098,1.0),
  ('JP.67580','2025-12-04',3143.4,3163,3129,3143.4,694076,1.0),
  ('JP.67580','2025-12-05',3165.8,3165.6,3147.7,3150.9,800251,1.0),
  ('JP.67580','2025-12-08',3139.3,3153.7,3102.4,3139.1,689985,1.0),
  ('JP.67580','2025-12-09',3145.6,3171.3,3131.5,3135,694031,1.0),
  ('JP.67580','2025-12-10',3146.8,3176.6,3121.7,3143.3,749901,1.0),
  ('JP.67580','2025-12-11',3141.7,3154.9,3101.2,3134,804666,1.0),
  ('JP.67580','2025-12-12',3136.7,3159.3,3139,3140.1,822025,1.0),
  ('JP.67580','2025-12-15',3116.3,3148.5,3120.9,3133,1016880,1.0),
  ('JP.67580','2025-12-16',3161.4,3173.3,3131.4,3149.1,926614,1.0),
  ('JP.67580','2025-12-17',3135.6,3156.6,3139.2,3141.9,1042818,1.0),
  ('JP.67580','2025-12-18',3128.7,3138.4,3100.4,3126.7,1070158,1.0),
  ('JP.67580','2025-12-19',3115.1,3159.6,3106.5,3131.6,1053773,1.0),
  ('JP.67580','2025-12-22',3156.3,3158.4,3119.1,3138.6,1167125,1.0),
  ('JP.67580','2025-12-23',3121.1,3147.3,3121.7,3134.5,1196140,1.0),
  ('JP.67580','2025-12-24',3167.1,3188.7,3124.2,3158.5,1053685,1.0),
  ('JP.67580','2025-12-25',3166.7,3180.6,3126,3152.9,1099711,1.0),
  ('JP.67580','2025-12-26',3184,3203.6,3157.5,3169.7,1108456,1.0),
  ('JP.67580','2025-12-29',3187.1,3172.8,3142.4,3171.7,1138201,1.0),
  ('JP.67580','2025-12-30',3160.6,3192.8,3144.4,3164.2,1208839,1.0),
  ('JP.67580','2025-12-31',3162,3207.3,3172.3,3172.6,1055266,1.0),
  ('JP.67580','2026-01-01',3138.9,3186.4,3124.8,3154,1110316,1.0),
  ('JP.67580','2026-01-02',3198.2,3231.4,3179.1,3193.5,1136636,1.0),
  ('JP.67580','2026-01-05',3158.3,3185.6,3154.3,3171.1,1102730,1.0),
  ('JP.67580','2026-01-06',3204.9,3201.7,3173.3,3188.3,1003034,1.0),
  ('JP.67580','2026-01-07',3189.6,3191.6,3154.8,3185.1,934497,1.0),
  ('JP.67580','2026-01-08',3187.3,3224.1,3178.1,3202.8,831530,1.0),
  ('JP.67580','2026-01-09',3195,3240.4,3167.9,3205.2,965490,1.0),
  ('JP.67580','2026-01-12',3191.4,3225.9,3180.9,3210.3,797646,1.0),
  ('JP.67580','2026-01-13',3224.3,3225.7,3189.9,3219.7,874377,1.0),
  ('JP.67580','2026-01-14',3228.9,3232.8,3212.3,3226.8,679116,1.0),
  ('JP.67580','2026-01-15',3231.3,3256.6,3216.7,3227.6,669085,1.0),
  ('JP.67580','2026-01-16',3255.5,3257.8,3210.4,3241.4,687478,1.0),
  ('JP.67580','2026-01-19',3257.9,3283.9,3230.5,3268.4,592210,1.0),
  ('JP.67580','2026-01-20',3257.9,3285.4,3245.3,3258.8,607898,1.0),
  ('JP.67580','2026-01-21',3271.4,3293.9,3226.5,3261.8,639192,1.0),
  ('JP.67580','2026-01-22',3289,3311.5,3280,3287.3,643425,1.0),
  ('JP.67580','2026-01-23',3292.7,3286.1,3263.3,3285.1,578334,1.0),
  ('JP.67580','2026-01-26',3281,3307.6,3260.1,3281.7,689790,1.0),
  ('JP.67580','2026-01-27',3304.4,3330.9,3301.9,3318.5,640806,1.0),
  ('JP.67580','2026-01-28',3343.6,3355.7,3321.5,3334.4,723212,1.0),
  ('JP.67580','2026-01-29',3323.8,3366,3332.5,3333.8,798184,1.0),
  ('JP.67580','2026-01-30',3348,3349.1,3332.7,3333.7,679191,1.0),
  ('JP.67580','2026-02-02',3380.9,3397.6,3329.3,3362.7,827244,1.0),
  ('JP.67580','2026-02-03',3372.9,3389.2,3332.1,3354.4,847289,1.0),
  ('JP.67580','2026-02-04',3369.5,3367.5,3347.1,3354,939237,1.0),
  ('JP.67580','2026-02-05',3347.7,3376.1,3339.6,3363.5,917996,1.0),
  ('JP.67580','2026-02-06',3393.5,3431.7,3382.5,3395.4,886196,1.0),
  ('JP.67580','2026-02-09',3397.1,3423,3386.8,3403.4,1005446,1.0),
  ('JP.67580','2026-02-10',3422.3,3420.3,3387.1,3417.6,1112467,1.0),
  ('JP.67580','2026-02-11',3419.9,3424.3,3376.7,3413.7,1146490,1.0),
  ('JP.67580','2026-02-12',3428.3,3459.6,3417.7,3430.6,1158120,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.67580','2026-02-13',3456.6,3486.2,3428.9,3445.9,1154946,1.0),
  ('JP.67580','2026-02-16',3464.6,3487.8,3418.7,3446.6,1104667,1.0),
  ('JP.67580','2026-02-17',3448.8,3462.3,3420.6,3449.6,1202240,1.0),
  ('JP.67580','2026-02-18',3452.9,3478.5,3453.6,3457.9,1245165,1.0),
  ('JP.67580','2026-02-19',3462.1,3479.2,3457.2,3474.9,1114596,1.0),
  ('JP.67580','2026-02-20',3496.2,3496.2,3470.4,3488,1122681,1.0),
  ('JP.67580','2026-02-23',3500.4,3521.3,3495.4,3503.5,1034995,1.0),
  ('JP.67580','2026-02-24',3468.2,3505.5,3468.8,3487.1,1075870,1.0),
  ('JP.67580','2026-02-25',3516.8,3539.3,3477.3,3502.6,1007702,1.0),
  ('JP.67580','2026-02-26',3497.1,3520.7,3471,3497.9,1020491,1.0),
  ('JP.67580','2026-02-27',3503.1,3514.4,3470.6,3507.6,916842,1.0),
  ('JP.67580','2026-03-02',3508.9,3541.2,3490,3523.7,843572,1.0),
  ('JP.67580','2026-03-03',3507.5,3534.8,3510.6,3526.9,860738,1.0),
  ('JP.67580','2026-03-04',3514.5,3539.1,3503.9,3525.9,855136,1.0),
  ('JP.67580','2026-03-05',3547.1,3542.1,3528.3,3541.6,783001,1.0),
  ('JP.67580','2026-03-06',3573,3559.1,3539.7,3553.8,693396,1.0),
  ('JP.67580','2026-03-09',3538.6,3563.6,3544.8,3551.4,822225,1.0),
  ('JP.67580','2026-03-10',3576.3,3588.7,3554.3,3566.5,675638,1.0),
  ('JP.67580','2026-03-11',3608.2,3598.1,3564.1,3588.5,697008,1.0),
  ('JP.67580','2026-03-12',3610.1,3617.6,3563.8,3590.5,691127,1.0),
  ('JP.67580','2026-03-13',3585.5,3614.2,3576,3595.9,724494,1.0),
  ('JP.67580','2026-03-16',3568.3,3588.1,3547.9,3581.4,706761,1.0),
  ('JP.67580','2026-03-17',3580.2,3588.4,3561.5,3579.8,691095,1.0),
  ('JP.67580','2026-03-18',3572.1,3607.2,3550.7,3582.9,663413,1.0),
  ('JP.67580','2026-03-19',3602.3,3629,3567.7,3608.3,766134,1.0),
  ('JP.67580','2026-03-20',3587.8,3637.2,3601.6,3607.4,743435,1.0),
  ('JP.67580','2026-03-23',3582.8,3620.6,3563.6,3588.4,685219,1.0),
  ('JP.67580','2026-03-24',3610.7,3614.3,3575.3,3591.3,750065,1.0),
  ('JP.67580','2026-03-25',3619.3,3625,3592.1,3605.6,742842,1.0),
  ('JP.67580','2026-03-26',3623.7,3638.8,3578.3,3617.7,820169,1.0),
  ('JP.67580','2026-03-27',3616.3,3664.2,3616.1,3628.4,835404,1.0),
  ('JP.67580','2026-03-30',3622.8,3624.3,3572.3,3604,955139,1.0),
  ('JP.67580','2026-03-31',3598.7,3603.6,3594.5,3601,899158,1.0),
  ('JP.67580','2026-04-01',3629,3631.1,3618.4,3628.8,1063543,1.0),
  ('JP.67580','2026-04-02',3622.4,3630.2,3591.9,3607.1,1104925,1.0),
  ('JP.67580','2026-04-03',3612.6,3644.3,3565.7,3602.5,1025730,1.0),
  ('JP.67580','2026-04-06',3646.6,3665.7,3616.5,3626.2,1115355,1.0),
  ('JP.67580','2026-04-07',3623.1,3636,3589.5,3626.4,1077443,1.0),
  ('JP.67580','2026-04-08',3600.4,3639.7,3600.1,3616.5,1093515,1.0),
  ('JP.67580','2026-04-09',3596.3,3640.8,3589.9,3603.5,1229276,1.0),
  ('JP.67580','2026-04-10',3631,3647.8,3583.7,3610.9,1186165,1.0),
  ('JP.67580','2026-04-13',3592.4,3628.2,3557,3599.2,1053820,1.0),
  ('JP.67580','2026-04-14',3614.7,3606.3,3578.5,3601.4,1203734,1.0),
  ('JP.67580','2026-04-15',3586.7,3622.4,3582.5,3598.4,1045245,1.0),
  ('JP.67580','2026-04-16',3601.3,3622.9,3592.8,3595.9,1194221,1.0),
  ('JP.67580','2026-04-17',3624.9,3625.4,3580.5,3606.1,1049251,1.0),
  ('JP.67580','2026-04-20',3567,3599.5,3558.3,3576.5,1072554,1.0),
  ('JP.67580','2026-04-21',3601.4,3618.5,3568.6,3581.5,1037326,1.0),
  ('JP.67580','2026-04-22',3566.8,3612,3536,3576.5,1032789,1.0),
  ('JP.67580','2026-04-23',3585.3,3603.8,3572.5,3589.9,920600,1.0),
  ('JP.67580','2026-04-24',3545.8,3584.1,3527,3561.8,850448,1.0),
  ('JP.67580','2026-04-27',3549.8,3586.4,3558.2,3570,827681,1.0),
  ('JP.67580','2026-04-28',3579.9,3618.4,3580.2,3583.6,788765,1.0),
  ('JP.67580','2026-04-29',3559.8,3560.4,3527,3551.5,670328,1.0),
  ('JP.67580','2026-04-30',3551.7,3607.1,3564.2,3570,768160,1.0),
  ('JP.67580','2026-05-01',3579.7,3596,3561,3565.3,753053,1.0),
  ('JP.67580','2026-05-04',3549.4,3543.1,3524.7,3539.1,755311,1.0),
  ('JP.67580','2026-05-05',3552,3595.2,3548.1,3555.1,610281,1.0),
  ('JP.67580','2026-05-06',3550.7,3567.4,3534.4,3541.5,689338,1.0),
  ('JP.67580','2026-05-07',3511,3565.4,3499.7,3525.5,640029,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.67580','2026-05-08',3511.4,3528.3,3497,3514.3,700312,1.0),
  ('JP.67580','2026-05-11',3546.9,3533.2,3501.7,3528.1,608745,1.0),
  ('JP.67580','2026-05-12',3488.8,3515.3,3491,3504.4,602004,1.0),
  ('JP.67580','2026-05-13',3491.1,3512.6,3476.8,3503.6,790359,1.0),
  ('JP.67580','2026-05-14',3502.2,3538.9,3479.3,3498.6,669091,1.0),
  ('JP.67580','2026-05-15',3493.9,3534.3,3455.8,3496.8,736368,1.0),
  ('JP.67580','2026-05-18',3489.6,3541.7,3489.1,3502.2,851395,1.0),
  ('JP.67580','2026-05-19',3473.7,3500.8,3450.5,3482.5,915352,1.0),
  ('JP.67580','2026-05-20',3517.7,3512.8,3487.4,3510.4,846623,1.0),
  ('JP.67580','2026-05-21',3482.9,3531.4,3479.1,3498.1,872169,1.0),
  ('JP.67580','2026-05-22',3465.3,3495.6,3460.7,3472.6,961051,1.0),
  ('JP.67580','2026-05-25',3497.1,3501.8,3474.9,3487.6,1001813,1.0),
  ('JP.67580','2026-05-26',3472.5,3479.1,3439.6,3477.1,1047160,1.0),
  ('JP.67580','2026-05-27',3505.7,3493.5,3462.8,3491,1072896,1.0),
  ('JP.67580','2026-05-28',3471.1,3468,3436,3458.8,1130821,1.0),
  ('JP.67580','2026-05-29',3449.1,3469,3444.2,3453.7,1133592,1.0),
  ('JP.67580','2026-06-01',3457.8,3482.4,3450.9,3471.8,1040850,1.0),
  ('JP.67580','2026-06-02',3451.5,3458.3,3424.7,3455.7,1151035,1.0),
  ('JP.67580','2026-06-03',3441.4,3489.3,3437.6,3461.3,1142990,1.0),
  ('JP.67580','2026-06-04',3428.4,3457.3,3404.1,3444.9,1136138,1.0),
  ('JP.67580','2026-06-05',3447.8,3474,3430.8,3454.3,1171243,1.0),
  ('JP.67580','2026-06-08',3476.3,3496.5,3433.2,3466.5,1152152,1.0),
  ('JP.67580','2026-06-09',3437.1,3454.6,3404.8,3441.1,1054367,1.0),
  ('JP.67580','2026-06-10',3474.8,3480.9,3445.6,3462.5,1159383,1.0),
  ('JP.67580','2026-06-11',3470.1,3461.6,3424.5,3459.5,966850,1.0),
  ('JP.67580','2026-06-12',3477.6,3463.5,3427.9,3461.3,1072941,1.0),
  ('JP.67580','2026-06-15',3435.3,3442.9,3395.3,3435.3,904212,1.0),
  ('JP.67580','2026-06-16',3442,3493,3452,3458.7,967691,1.0),
  ('JP.67580','2026-06-17',3419.6,3439.4,3399.5,3434.9,904572,1.0),
  ('JP.67580','2026-06-18',3454.7,3451.4,3407.9,3440.3,817091,1.0),
  ('JP.67580','2026-06-19',3472.4,3493.5,3439.1,3457.5,724622,1.0),
  ('JP.67580','2026-06-22',3451.1,3473.5,3421.3,3440.8,763030,1.0),
  ('JP.67580','2026-06-23',3472.1,3506.4,3445,3466.3,740805,1.0),
  ('JP.67580','2026-06-24',3450.7,3466.6,3436.1,3465.7,644420,1.0),
  ('JP.67580','2026-06-25',3462.7,3475.6,3423.8,3460.4,598332,1.0),
  ('JP.67580','2026-06-26',3430.2,3481.7,3446.9,3448.2,625801,1.0),
  ('JP.67580','2026-06-29',3464,3498.8,3436.5,3463.2,683908,1.0),
  ('JP.67580','2026-06-30',3476.6,3498.4,3440.6,3468.4,625984,1.0),
  ('JP.67580','2026-07-01',3457.1,3474.5,3450,3461.4,565482,1.0),
  ('JP.67580','2026-07-02',3484.3,3512.4,3477.9,3491,713327,1.0),
  ('JP.67580','2026-07-03',3471.4,3490.7,3451,3470.5,736199,1.0),
  ('JP.67580','2026-07-06',3471,3481.9,3474.9,3480,671155,1.0),
  ('JP.67580','2026-07-07',3485.7,3532.1,3453.9,3494.2,832731,1.0),
  ('JP.67580','2026-07-08',3525.8,3520.6,3479.1,3511,806490,1.0),
  ('JP.67580','2026-07-09',3517.6,3512.9,3508.6,3510.9,782703,1.0),
  ('JP.67580','2026-07-10',3497.1,3498.6,3480.3,3496.5,940290,1.0),
  ('JP.67580','2026-07-13',3497,3536.5,3490.7,3506.3,984513,1.0),
  ('JP.67580','2026-07-14',3527.7,3531.2,3488.2,3510,840190,1.0),
  ('JP.67580','2026-07-15',3547.9,3578.7,3541,3547.6,1048006,1.0),
  ('JP.67580','2026-07-16',3526,3556.2,3510.8,3535.1,1099885,1.0),
  ('JP.67580','2026-07-17',3536.8,3557.5,3548.5,3552.7,1138722,1.0),
  ('JP.67580','2026-07-20',3539,3570.8,3522.6,3553.2,1095261,1.0),
  ('JP.67580','2026-07-21',3550.2,3607.4,3565.3,3570.6,1184215,1.0),
  ('JP.67580','2026-07-22',3543.5,3571.7,3530.4,3557.7,1118641,1.0),
  ('JP.67580','2026-07-23',3574.7,3609.8,3567,3569.4,1230836,1.0),
  ('JP.67580','2026-07-24',3605.7,3615,3569,3587.6,1171639,1.0),
  ('JP.67580','2026-07-27',3599.9,3600.4,3561.4,3593.7,1095833,1.0),
  ('JP.67580','2026-07-28',3595.3,3631.1,3599.7,3615.5,1146531,1.0),
  ('JP.67580','2026-07-29',3635.6,3648.6,3586.9,3617.5,1055137,1.0),
  ('JP.67580','2026-07-30',3615,3645.8,3582.7,3619.6,1108320,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.67580','2026-07-31',3605.5,3658.8,3615.9,3623.5,1054317,1.0),
  ('JP.67580','2026-08-03',3625.8,3677.4,3634.9,3647.6,1067229,1.0),
  ('JP.67580','2026-08-04',3633.9,3659.4,3607.4,3637.2,941354,1.0),
  ('JP.67580','2026-08-05',3638,3663.2,3641.6,3654.1,1066757,1.0),
  ('JP.67580','2026-08-06',3652.4,3680.6,3654.8,3666.2,907598,1.0),
  ('JP.67580','2026-08-07',3676.9,3693.5,3679,3679.6,968116,1.0),
  ('JP.67580','2026-08-10',3690.5,3706.3,3683.8,3696.8,800094,1.0),
  ('JP.67580','2026-08-11',3709.8,3732.4,3693.2,3695.7,850403,1.0),
  ('JP.67580','2026-08-12',3708.5,3716.4,3698.4,3702,846780,1.0),
  ('JP.67580','2026-08-13',3729,3725.4,3706.8,3722.7,829636,1.0),
  ('JP.67580','2026-08-14',3731.5,3763.9,3692.6,3720.8,728481,1.0),
  ('JP.67580','2026-08-17',3750.3,3787.2,3737.7,3754,591434,1.0),
  ('JP.67580','2026-08-18',3751.5,3785.1,3732.2,3750.5,650578,1.0),
  ('JP.67580','2026-08-19',3763.6,3798.2,3755.1,3767.2,594005,1.0),
  ('JP.67580','2026-08-20',3775.4,3810.8,3756.7,3774.9,625197,1.0),
  ('JP.67580','2026-08-21',3756.1,3768.6,3734.5,3764.5,592838,1.0),
  ('JP.67580','2026-08-24',3804.4,3803.2,3773.6,3787.8,584377,1.0),
  ('JP.67580','2026-08-25',3794.6,3822.4,3760.9,3785.5,628507,1.0),
  ('JP.67580','2026-08-26',3779.7,3836.8,3769.8,3798.1,718216,1.0),
  ('JP.67580','2026-08-27',3845.5,3832.4,3817.9,3829.5,766819,1.0);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-03',50.54,-3.07,-8.58,5.51,3470.9,3457.66,3524.91,3379.88,47.34,821058.45,0.8966,0.00469,-0.038882,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-03','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-03','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-03','v1-technical',64,10,10,10,10,4,7,NULL,NULL,'BUY_WATCH',3470.5,3423.08,3612.51,2.995);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-06',52.9,-1.63,-7.19,5.56,3474.26,3457.99,3523.47,3380.79,44.77,797008.6,0.8421,0.003894,-0.033118,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-06','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-06','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-06','v1-technical',68,10,10,13,10,4,7,NULL,NULL,'BUY_WATCH',3480,3423.41,3614.31,2.373);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-07',56.25,0.66,-5.62,6.28,3479.42,3459.53,3522.17,3381.77,47.16,785926.8,1.0596,0.015431,-0.029766,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-07','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-07','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-07','v1-technical',70,10,10,15,10,4,7,NULL,NULL,'BUY_WATCH',3494.2,3424.93,3635.67,2.042);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-08',59.89,3.78,-3.74,7.52,3489.34,3461.52,3520.91,3382.87,46.75,768282.15,1.0497,0.014007,-0.024289,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-08','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-08','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-08','v1-technical',70,10,10,15,10,4,7,NULL,NULL,'BUY_WATCH',3511,3426.9,3651.26,1.668);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-09',59.86,6.17,-1.76,7.93,3493.32,3464.16,3519.49,3383.91,43.72,759074.8,1.0311,0.014858,-0.023638,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-09','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-09','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-09','v1-technical',70,10,10,15,10,4,7,NULL,NULL,'BUY_WATCH',3510.9,3429.51,3642.07,1.612);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-10',55.29,6.83,-0.04,6.87,3498.52,3465.84,3517.73,3384.84,42.78,752442.25,1.2497,0.01017,-0.030393,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-10','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-10','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-10','v1-technical',71,10,10,12,10,8,7,NULL,NULL,'BUY_WATCH',3496.5,3431.19,3624.85,1.965);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-13',57.66,8.05,1.58,6.47,3503.78,3467.44,3516.43,3385.8,43,756457.3,1.3015,0.020668,-0.019628,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-13','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-13','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-13','v1-technical',71,10,10,12,10,8,7,NULL,NULL,'BUY_WATCH',3506.3,3432.76,3635.3,1.754);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-14',58.55,9.21,3.11,6.1,3506.94,3470.19,3515.21,3386.88,43,750082.25,1.1201,0.014832,-0.019964,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-14','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-14','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-14','v1-technical',66,10,10,12,10,4,7,NULL,NULL,'BUY_WATCH',3510,3435.49,3639,1.731);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-15',66.32,13.01,5.09,7.92,3514.26,3473.6,3514.13,3388.17,44.84,757253.95,1.384,0.03281,-0.008081,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-15','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-15','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-15','v1-technical',79,15,8,15,10,8,7,NULL,NULL,'BUY_NOW',3547.6,3438.86,3682.11,1.237);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-16',62.15,14.84,7.04,7.81,3519.1,3476.62,3513.17,3389.47,44.88,771393.65,1.4258,0.027556,-0.015265,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-16','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-16','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-16','v1-technical',78,15,10,12,10,8,7,NULL,NULL,'BUY_NOW',3535.1,3441.85,3669.73,1.444);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-17',65.45,17.52,9.13,8.38,3530.34,3480.28,3512.51,3390.76,43.27,792098.65,1.4376,0.027534,-0.002555,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-17','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-17','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-17','v1-technical',79,15,8,15,10,8,7,NULL,NULL,'BUY_NOW',3552.7,3445.47,3682.51,1.211);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-20',65.54,19.45,11.2,8.25,3539.72,3484.99,3511.53,3392.04,43.62,808710.2,1.3543,0.032667,-0.004706,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-20','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-20','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-20','v1-technical',75,15,8,12,10,8,7,NULL,NULL,'BUY_NOW',3553.2,3450.14,3684.07,1.27);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-21',68.66,22.13,13.38,8.75,3551.84,3489.47,3510.79,3393.44,44.38,830880.7,1.4253,0.03009,-0.003628,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-21','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-21','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-21','v1-technical',79,15,8,15,10,8,7,NULL,NULL,'BUY_WATCH',3570.6,3454.57,3703.73,1.147);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-22',64.03,22.95,15.3,7.65,3553.86,3494.38,3510,3394.82,44.16,854591.75,1.309,0.026546,0.001746,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-22','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-22','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-22','v1-technical',81,15,10,12,10,8,10,NULL,NULL,'BUY_NOW',3557.7,3459.44,3690.17,1.348);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-23',66.25,24.26,17.09,7.17,3560.72,3499.54,3509.55,3396.24,44.73,886216.95,1.3889,0.031499,-0.000168,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-23','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-23','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-23','v1-technical',75,15,8,12,10,8,7,NULL,NULL,'BUY_NOW',3569.4,3464.55,3703.58,1.28);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-24',69.42,26.47,18.96,7.5,3567.7,3504.75,3509.24,3397.73,44.82,913508.85,1.2826,0.040427,0.006255,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-24','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-24','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-24','v1-technical',83,15,8,15,10,8,10,NULL,NULL,'BUY_WATCH',3587.6,3469.7,3722.05,1.14);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-27',70.42,28.38,20.85,7.53,3575.8,3510.86,3509.17,3399.34,44.4,934105.1,1.1731,0.037682,0.015428,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-27','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-27','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-27','v1-technical',79,15,4,15,15,4,10,NULL,NULL,'BUY_WATCH',3593.7,3475.76,3726.9,1.129);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-28',73.73,31.29,22.94,8.36,3584.78,3516.83,3509.35,3401.01,43.9,960132.45,1.1941,0.042411,0.01699,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-28','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-28','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-28','v1-technical',85,20,4,15,15,4,10,NULL,NULL,'BUY_WATCH',3615.5,3527.7,3747.2,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-29',74.02,33.38,25.03,8.35,3596.74,3522.9,3509.61,3402.85,45.17,984615.2,1.0716,0.045097,0.02146,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-29','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-29','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-29','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',3617.5,3527.16,3753.02,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-30',74.33,34.8,26.98,7.82,3606.78,3529.27,3509.92,3404.71,46.45,1004364.85,1.1035,0.036838,0.026691,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-30','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-30','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-30','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',3619.6,3493.98,3758.96,1.109);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-07-31',74.95,35.83,28.75,7.08,3613.96,3536.28,3510.16,3406.55,46.2,1020270.75,1.0334,0.044086,0.031073,3628.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-31','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-07-31','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-07-31','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',3623.5,3500.92,3762.1,1.131);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-03',78.38,38.15,30.63,7.52,3624.74,3543.66,3511.1,3408.6,46.75,1040074.45,1.0261,0.048161,0.033871,3647.6,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-03','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-03','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-03','v1-technical',85,20,4,15,15,4,10,NULL,NULL,'BUY_WATCH',3647.6,3554.1,3787.85,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-04',73.69,38.7,32.24,6.46,3629.08,3550.41,3511.85,3410.58,47.12,1045505.6,0.9004,0.040925,0.037895,3647.6,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-04','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-04','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-04','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',3637.2,3514.91,3778.57,1.156);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-05',76.18,40.04,33.8,6.24,3636.4,3558.12,3512.88,3412.59,45.62,1058518.95,1.0078,0.040758,0.042956,3654.1,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-05','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-05','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-05','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',3654.1,3562.87,3790.95,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-06',77.8,41.6,35.36,6.24,3645.72,3565.13,3513.9,3414.71,44.25,1064763.7,0.8524,0.044234,0.047905,3666.2,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-06','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-06','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-06','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',3666.2,3577.7,3798.95,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-07',79.47,43.42,36.97,6.44,3656.94,3573.49,3515.47,3417.03,43.04,1066155,0.908,0.052367,0.052276,3679.6,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-07','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-07','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-07','v1-technical',85,20,4,15,15,4,10,NULL,NULL,'BUY_WATCH',3679.6,3593.52,3808.72,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-10',81.4,45.72,38.72,7,3666.78,3582.16,3517.16,3419.44,41.87,1056934.05,0.757,0.054331,0.055565,3696.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-10','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-10','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-10','v1-technical',78,20,1,15,15,1,10,NULL,NULL,'BUY_WATCH',3696.8,3613.06,3822.42,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-11',80.88,46.91,40.36,6.55,3678.48,3590.22,3518.65,3421.88,41.68,1057444.7,0.8042,0.052906,0.06122,3696.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-11','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-11','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-11','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3695.7,3612.34,3820.74,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-12',81.61,47.81,41.85,5.96,3688.06,3597.86,3520.66,3424.32,40.18,1047383.4,0.8085,0.043522,0.054581,3702,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-12','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-12','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-12','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3702,3621.63,3822.55,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-13',83.8,49.63,43.41,6.22,3699.36,3606.34,3522.7,3426.96,38.98,1033870.95,0.8025,0.053068,0.064206,3722.7,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-13','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-13','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-13','v1-technical',81,20,1,15,15,4,10,NULL,NULL,'BUY_WATCH',3722.7,3644.73,3839.65,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-14',82.83,50.33,44.79,5.54,3707.6,3615.31,3524.77,3429.46,41.29,1013358.9,0.7189,0.047316,0.071474,3722.7,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-14','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-14','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-14','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3720.8,3638.22,3844.68,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-17',85.91,52.96,46.42,6.53,3719.04,3625.22,3527.64,3432.14,43.09,988167.55,0.5985,0.056512,0.076385,3754,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-17','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-17','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-17','v1-technical',78,20,1,15,15,1,10,NULL,NULL,'BUY_WATCH',3754,3667.83,3883.26,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-18',84.19,54.13,47.97,6.17,3730,3634.84,3530.24,3434.84,43.79,961485.7,0.6766,0.050384,0.078629,3754,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-18','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-18','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-18','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3750.5,3662.93,3881.86,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-19',85.66,55.77,49.53,6.24,3743.04,3643.62,3533.25,3437.7,44.07,935253.9,0.6351,0.058886,0.079118,3767.2,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-19','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-19','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-19','v1-technical',78,20,1,15,15,1,10,NULL,NULL,'BUY_WATCH',3767.2,3679.07,3899.4,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-20',86.3,57.03,51.03,6,3753.48,3653.21,3536.58,3440.59,44.78,904971.95,0.6908,0.057573,0.09139,3774.9,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-20','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-20','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-20','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3774.9,3685.33,3909.25,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-21',81.09,56.54,52.13,4.41,3762.22,3661.68,3539.91,3443.52,44.47,876031.9,0.6767,0.049309,0.08999,3774.9,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-21','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-21','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-21','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3764.5,3675.56,3897.91,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-24',83.49,57.37,53.18,4.19,3768.98,3671.07,3543.37,3446.55,44.06,850459.1,0.6871,0.054011,0.091019,3787.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-24','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-24','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-24','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3787.8,3699.68,3919.97,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-25',82.38,57.18,53.98,3.2,3775.98,3679.66,3547.12,3449.55,45.3,824557.9,0.7622,0.04702,0.095437,3787.8,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-25','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-25','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-25','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3785.5,3694.89,3921.41,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-26',83.66,57.39,54.66,2.73,3782.16,3689.28,3551.05,3452.68,46.85,807711.85,0.8892,0.049924,0.097304,3798.1,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-26','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-26','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-26','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3798.1,3704.39,3938.66,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.67580','2026-08-27',86.34,59.4,55.61,3.79,3793.08,3699.68,3555.46,3455.98,45.96,790636.8,0.9699,0.05799,0.111643,3829.5,3124.4);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-27','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.67580','2026-08-27','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.67580','2026-08-27','v1-technical',81,20,1,15,15,4,10,NULL,NULL,'BUY_WATCH',3829.5,3737.59,3967.37,1.5);

INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.72030','2025-08-29',2495.1,2512.8,2493.9,2509.2,980619,1.0),
  ('JP.72030','2025-09-01',2497.9,2520.2,2495.1,2507.9,933110,1.0),
  ('JP.72030','2025-09-02',2531.6,2527.5,2517.6,2525.1,1079955,1.0),
  ('JP.72030','2025-09-03',2513.9,2531,2477.5,2507.2,1103541,1.0),
  ('JP.72030','2025-09-04',2511.1,2534.8,2495.5,2506,1107982,1.0),
  ('JP.72030','2025-09-05',2522.6,2536.5,2515.6,2518.6,1121618,1.0),
  ('JP.72030','2025-09-08',2522.2,2526.3,2494.9,2516.6,1148120,1.0),
  ('JP.72030','2025-09-09',2507.6,2533.5,2496.7,2504.2,1071150,1.0),
  ('JP.72030','2025-09-10',2511.7,2520.5,2485.1,2502.5,1146816,1.0),
  ('JP.72030','2025-09-11',2483.3,2497.5,2489.2,2494.4,1114835,1.0),
  ('JP.72030','2025-09-12',2504.3,2540.4,2500.2,2511.6,1172924,1.0),
  ('JP.72030','2025-09-15',2489.2,2510.1,2491.4,2499.1,1211019,1.0),
  ('JP.72030','2025-09-16',2507.1,2516.5,2505.3,2513.6,1130368,1.0),
  ('JP.72030','2025-09-17',2489.1,2490.1,2467.8,2484.8,1018181,1.0),
  ('JP.72030','2025-09-18',2495.8,2509.6,2479.9,2482.2,1138330,1.0),
  ('JP.72030','2025-09-19',2490.2,2515.1,2463.5,2491.3,965359,1.0),
  ('JP.72030','2025-09-22',2510.3,2508.6,2470.3,2497.9,1005937,1.0),
  ('JP.72030','2025-09-23',2488.6,2502.3,2477.1,2484.2,1047439,1.0),
  ('JP.72030','2025-09-24',2485.4,2514.2,2466.4,2488.4,1030204,1.0),
  ('JP.72030','2025-09-25',2470.2,2477.5,2465.9,2477.2,867743,1.0),
  ('JP.72030','2025-09-26',2478,2477.7,2442.4,2468.5,949353,1.0),
  ('JP.72030','2025-09-29',2464.2,2477.1,2465.7,2470.8,759166,1.0),
  ('JP.72030','2025-09-30',2445,2472.8,2434.4,2457.5,801040,1.0),
  ('JP.72030','2025-10-01',2439.2,2478.6,2430.4,2450.1,731746,1.0),
  ('JP.72030','2025-10-02',2460.6,2468.5,2434.7,2463.5,678975,1.0),
  ('JP.72030','2025-10-03',2442.9,2455.9,2413.2,2434.5,681455,1.0),
  ('JP.72030','2025-10-06',2429.2,2467.5,2430.2,2440.5,664435,1.0),
  ('JP.72030','2025-10-07',2433.8,2450.4,2404,2424.5,614757,1.0),
  ('JP.72030','2025-10-08',2441.1,2459.3,2437.5,2447.3,743737,1.0),
  ('JP.72030','2025-10-09',2413.1,2433.7,2404.1,2416.8,558468,1.0),
  ('JP.72030','2025-10-10',2426.8,2455.1,2414.2,2430.3,621362,1.0),
  ('JP.72030','2025-10-13',2425.1,2440.1,2396.6,2423.9,597317,1.0),
  ('JP.72030','2025-10-14',2404,2413.2,2374.7,2400,613554,1.0),
  ('JP.72030','2025-10-15',2407.7,2419.4,2402.5,2417.6,674708,1.0),
  ('JP.72030','2025-10-16',2430.8,2417.4,2408,2416.9,771487,1.0),
  ('JP.72030','2025-10-17',2397.8,2426.2,2384.9,2408.7,868148,1.0),
  ('JP.72030','2025-10-20',2398.2,2401.5,2388.5,2392.4,848847,1.0),
  ('JP.72030','2025-10-21',2390.7,2407.7,2357.4,2379.9,772048,1.0),
  ('JP.72030','2025-10-22',2372.5,2408.3,2368.9,2383.4,1008529,1.0),
  ('JP.72030','2025-10-23',2371.8,2410.1,2376.7,2383.8,1049661,1.0),
  ('JP.72030','2025-10-24',2367.3,2385.3,2365.2,2371.1,1069568,1.0),
  ('JP.72030','2025-10-27',2382.8,2401.9,2362.4,2381.3,1115347,1.0),
  ('JP.72030','2025-10-28',2366,2359.2,2341.7,2356.8,1140910,1.0),
  ('JP.72030','2025-10-29',2353.5,2367.7,2349.7,2360.9,1140512,1.0),
  ('JP.72030','2025-10-30',2351.5,2360.9,2357.2,2358.8,1085691,1.0),
  ('JP.72030','2025-10-31',2355.5,2372.9,2350.3,2363.5,1104149,1.0),
  ('JP.72030','2025-11-03',2358.4,2347.2,2334.9,2345.5,1120810,1.0),
  ('JP.72030','2025-11-04',2338.7,2362.4,2322.7,2343.4,1094245,1.0),
  ('JP.72030','2025-11-05',2345.9,2367.1,2331.7,2347.5,1194326,1.0),
  ('JP.72030','2025-11-06',2350.8,2351,2342.7,2350.8,1072008,1.0),
  ('JP.72030','2025-11-07',2353.9,2378.7,2325.6,2351,1109942,1.0),
  ('JP.72030','2025-11-10',2346,2359.8,2337,2339,1099366,1.0),
  ('JP.72030','2025-11-11',2333.7,2369.9,2321.2,2345.2,1096246,1.0),
  ('JP.72030','2025-11-12',2331.3,2332.8,2301.8,2329.4,964032,1.0),
  ('JP.72030','2025-11-13',2334,2338.2,2301.1,2328.8,960747,1.0),
  ('JP.72030','2025-11-14',2319.7,2324.6,2299.9,2324.5,878037,1.0),
  ('JP.72030','2025-11-17',2321.7,2353.3,2300.7,2327.7,937764,1.0),
  ('JP.72030','2025-11-18',2330.3,2344.5,2317.6,2322.3,837615,1.0),
  ('JP.72030','2025-11-19',2326.5,2353,2310.8,2328.2,747245,1.0),
  ('JP.72030','2025-11-20',2337.2,2342.2,2313.3,2325.1,777055,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.72030','2025-11-21',2356.2,2348.9,2319.6,2343,841195,1.0),
  ('JP.72030','2025-11-24',2322,2345.3,2327.5,2333.6,789208,1.0),
  ('JP.72030','2025-11-25',2315.1,2340.1,2323.8,2326.6,638042,1.0),
  ('JP.72030','2025-11-26',2307.6,2322.9,2310.9,2317.2,683193,1.0),
  ('JP.72030','2025-11-27',2343.5,2354.6,2327.5,2329.5,745459,1.0),
  ('JP.72030','2025-11-28',2349.8,2361.4,2318.1,2339,568005,1.0),
  ('JP.72030','2025-12-01',2329.3,2327.7,2292.3,2319.8,661434,1.0),
  ('JP.72030','2025-12-02',2330.4,2359.6,2333.6,2333.8,651699,1.0),
  ('JP.72030','2025-12-03',2339.5,2344.7,2338.2,2343.9,634137,1.0),
  ('JP.72030','2025-12-04',2314.2,2348.4,2299.9,2326.3,592075,1.0),
  ('JP.72030','2025-12-05',2328.4,2346,2327,2341.2,766041,1.0),
  ('JP.72030','2025-12-08',2337.7,2368.1,2344.6,2349.9,788875,1.0),
  ('JP.72030','2025-12-09',2332.6,2361.9,2337.2,2341.8,679105,1.0),
  ('JP.72030','2025-12-10',2341.8,2362.7,2323.9,2346.1,731862,1.0),
  ('JP.72030','2025-12-11',2342.4,2366.7,2341.5,2352.4,828364,1.0),
  ('JP.72030','2025-12-12',2358.9,2389.4,2360.2,2372.2,976351,1.0),
  ('JP.72030','2025-12-15',2359.8,2392.7,2357.1,2364.5,873241,1.0),
  ('JP.72030','2025-12-16',2350.9,2363.9,2361.8,2363.5,870284,1.0),
  ('JP.72030','2025-12-17',2393.1,2399.7,2371.2,2385.1,1102046,1.0),
  ('JP.72030','2025-12-18',2395.9,2409.1,2355.2,2381.7,1067229,1.0),
  ('JP.72030','2025-12-19',2375.2,2386.6,2378.2,2378.3,1167796,1.0),
  ('JP.72030','2025-12-22',2388.9,2413.9,2382.7,2399.8,1090376,1.0),
  ('JP.72030','2025-12-23',2388.2,2423.5,2380.9,2399.4,1045201,1.0),
  ('JP.72030','2025-12-24',2400.5,2397,2381,2394.5,1226044,1.0),
  ('JP.72030','2025-12-25',2394.8,2422.9,2389.9,2400.4,1172056,1.0),
  ('JP.72030','2025-12-26',2407.8,2413.9,2389,2397.3,1184040,1.0),
  ('JP.72030','2025-12-29',2421.8,2433.4,2411.1,2427.3,1105597,1.0),
  ('JP.72030','2025-12-30',2420.5,2437.2,2411.8,2420.3,1128800,1.0),
  ('JP.72030','2025-12-31',2430.8,2462.6,2420,2433.6,1118417,1.0),
  ('JP.72030','2026-01-01',2434.8,2432.4,2404.9,2426.1,1022224,1.0),
  ('JP.72030','2026-01-02',2457.3,2456,2430.3,2451,1091537,1.0),
  ('JP.72030','2026-01-05',2467.3,2460.3,2441.9,2453,988842,1.0),
  ('JP.72030','2026-01-06',2445,2468.5,2433.3,2455,1046849,1.0),
  ('JP.72030','2026-01-07',2450.8,2449.4,2434.8,2448.6,979049,1.0),
  ('JP.72030','2026-01-08',2444.6,2464.2,2440.3,2456.4,1009814,1.0),
  ('JP.72030','2026-01-09',2452.7,2479.3,2438,2461.4,829028,1.0),
  ('JP.72030','2026-01-12',2469.1,2491.9,2453.6,2483.4,818539,1.0),
  ('JP.72030','2026-01-13',2487.1,2489.2,2467,2477.7,859156,1.0),
  ('JP.72030','2026-01-14',2488,2506.8,2481.8,2499.1,709598,1.0),
  ('JP.72030','2026-01-15',2501.6,2518.1,2497.1,2498.6,678714,1.0),
  ('JP.72030','2026-01-16',2491,2524.9,2495.3,2497.7,626858,1.0),
  ('JP.72030','2026-01-19',2499.6,2505,2489.6,2502.1,635979,1.0),
  ('JP.72030','2026-01-20',2528.6,2523.8,2489,2517.5,729387,1.0),
  ('JP.72030','2026-01-21',2512,2538,2490.1,2510.3,631916,1.0),
  ('JP.72030','2026-01-22',2535.6,2544.3,2504.2,2531,731019,1.0),
  ('JP.72030','2026-01-23',2542.2,2564.7,2535.3,2539.8,565052,1.0),
  ('JP.72030','2026-01-26',2565.8,2567.5,2533.4,2553.1,599586,1.0),
  ('JP.72030','2026-01-27',2542.4,2553.8,2537.2,2550.6,757331,1.0),
  ('JP.72030','2026-01-28',2545.6,2565.1,2524.4,2555.1,790899,1.0),
  ('JP.72030','2026-01-29',2558.1,2574.1,2543.3,2553.6,688248,1.0),
  ('JP.72030','2026-01-30',2552,2577.5,2529.5,2548.6,703651,1.0),
  ('JP.72030','2026-02-02',2558.2,2590.1,2567.8,2568.3,899882,1.0),
  ('JP.72030','2026-02-03',2585,2592.4,2573,2582.9,829058,1.0),
  ('JP.72030','2026-02-04',2575.9,2593.7,2553.5,2574.6,991075,1.0),
  ('JP.72030','2026-02-05',2566.9,2577.3,2564.7,2571.8,845804,1.0),
  ('JP.72030','2026-02-06',2580.5,2590.1,2544.6,2572.7,1057430,1.0),
  ('JP.72030','2026-02-09',2599.1,2610.2,2578.8,2586,1089122,1.0),
  ('JP.72030','2026-02-10',2575.1,2597.6,2555.8,2580.7,1117612,1.0),
  ('JP.72030','2026-02-11',2603.8,2598.1,2568.5,2594,1115235,1.0),
  ('JP.72030','2026-02-12',2615.3,2621.3,2585.3,2615,1057964,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.72030','2026-02-13',2623.1,2617.8,2602.8,2612.8,1101290,1.0),
  ('JP.72030','2026-02-16',2595.5,2609.3,2589.3,2605,1189425,1.0),
  ('JP.72030','2026-02-17',2612.1,2618.1,2581.1,2597.5,1078952,1.0),
  ('JP.72030','2026-02-18',2616.1,2612.9,2580.6,2603.6,1105428,1.0),
  ('JP.72030','2026-02-19',2589.6,2630.4,2583,2604.9,1109418,1.0),
  ('JP.72030','2026-02-20',2593.3,2608.9,2599,2608.4,1119536,1.0),
  ('JP.72030','2026-02-23',2626,2619.9,2601.9,2616.1,1181240,1.0),
  ('JP.72030','2026-02-24',2597.7,2637.6,2586,2612.6,1009470,1.0),
  ('JP.72030','2026-02-25',2639.8,2645.7,2614.1,2626.8,1062608,1.0),
  ('JP.72030','2026-02-26',2618.1,2654.4,2612.1,2632.7,1062350,1.0),
  ('JP.72030','2026-02-27',2629.6,2652.2,2608.6,2634.2,1079021,1.0),
  ('JP.72030','2026-03-02',2618.5,2634.2,2602.9,2621.7,967008,1.0),
  ('JP.72030','2026-03-03',2610,2623.5,2606.5,2618.5,828130,1.0),
  ('JP.72030','2026-03-04',2611.1,2619.1,2600.8,2610.8,895558,1.0),
  ('JP.72030','2026-03-05',2622.3,2640.4,2601.5,2625.3,898463,1.0),
  ('JP.72030','2026-03-06',2628.5,2635.2,2598.8,2620.7,820508,1.0),
  ('JP.72030','2026-03-09',2615.4,2646.2,2626.3,2630.5,740187,1.0),
  ('JP.72030','2026-03-10',2621.6,2626.8,2597.8,2624.1,688162,1.0),
  ('JP.72030','2026-03-11',2627.3,2643.2,2581.7,2612.1,656613,1.0),
  ('JP.72030','2026-03-12',2606.9,2625.6,2601.1,2607,576275,1.0),
  ('JP.72030','2026-03-13',2623.2,2621.7,2577.5,2607.8,657185,1.0),
  ('JP.72030','2026-03-16',2618.8,2641.3,2622.1,2623.3,566463,1.0),
  ('JP.72030','2026-03-17',2612.4,2611.8,2603.5,2610.1,748844,1.0),
  ('JP.72030','2026-03-18',2611.4,2631,2604.5,2617.3,622192,1.0),
  ('JP.72030','2026-03-19',2598,2612.5,2597.8,2611.1,755313,1.0),
  ('JP.72030','2026-03-20',2587,2591.5,2587.3,2590.3,643833,1.0),
  ('JP.72030','2026-03-23',2609.8,2614.6,2601.9,2613.5,655582,1.0),
  ('JP.72030','2026-03-24',2610.9,2607.9,2569.3,2596,735681,1.0),
  ('JP.72030','2026-03-25',2581.4,2584.1,2572.2,2583.3,736154,1.0),
  ('JP.72030','2026-03-26',2573,2584.4,2558.2,2574.7,728608,1.0),
  ('JP.72030','2026-03-27',2582.6,2602.1,2558.3,2583.3,868966,1.0),
  ('JP.72030','2026-03-30',2569.5,2581.4,2563.5,2572.2,818584,1.0),
  ('JP.72030','2026-03-31',2562.9,2590.5,2543.5,2565.1,970798,1.0),
  ('JP.72030','2026-04-01',2559.4,2569.6,2557.7,2560.7,968177,1.0),
  ('JP.72030','2026-04-02',2550.3,2553.7,2523.5,2553.5,1082979,1.0),
  ('JP.72030','2026-04-03',2561.3,2573.1,2549,2558.9,1137857,1.0),
  ('JP.72030','2026-04-06',2560.9,2595.6,2539.8,2569.4,1144744,1.0),
  ('JP.72030','2026-04-07',2559.8,2586.5,2543.1,2561.2,1028948,1.0),
  ('JP.72030','2026-04-08',2545.9,2544.2,2525.8,2544,1132224,1.0),
  ('JP.72030','2026-04-09',2551.1,2553.7,2530.2,2545.3,1092927,1.0),
  ('JP.72030','2026-04-10',2530.9,2570.2,2514.6,2540.7,1210257,1.0),
  ('JP.72030','2026-04-13',2529.3,2556.2,2509.1,2537.2,1054959,1.0),
  ('JP.72030','2026-04-14',2528.7,2527.2,2496.9,2523.2,1208489,1.0),
  ('JP.72030','2026-04-15',2540.8,2544.8,2516.7,2530.1,1175533,1.0),
  ('JP.72030','2026-04-16',2533.3,2530.3,2494.7,2518.8,1099065,1.0),
  ('JP.72030','2026-04-17',2516.8,2523.5,2522.1,2523.2,1095409,1.0),
  ('JP.72030','2026-04-20',2510.3,2498.5,2481.1,2498.3,1133151,1.0),
  ('JP.72030','2026-04-21',2506,2546.5,2498.7,2518.3,1038209,1.0),
  ('JP.72030','2026-04-22',2489.5,2506.7,2465.8,2495.6,899982,1.0),
  ('JP.72030','2026-04-23',2474.6,2504.8,2471.1,2485,944432,1.0),
  ('JP.72030','2026-04-24',2498.8,2527.8,2472.6,2502.1,917714,1.0),
  ('JP.72030','2026-04-27',2472.7,2477.5,2471.7,2473.7,842954,1.0),
  ('JP.72030','2026-04-28',2472.1,2491.1,2460.2,2473.2,862403,1.0),
  ('JP.72030','2026-04-29',2475.6,2502.9,2458.6,2478.5,793617,1.0),
  ('JP.72030','2026-04-30',2487.5,2497.8,2455.5,2481.5,702646,1.0),
  ('JP.72030','2026-05-01',2484.3,2484.6,2469.1,2481,719875,1.0),
  ('JP.72030','2026-05-04',2453.2,2486.3,2456.8,2458.1,645080,1.0),
  ('JP.72030','2026-05-05',2489.4,2490.5,2464.8,2476.6,756167,1.0),
  ('JP.72030','2026-05-06',2460.7,2466.4,2439.5,2446.2,622707,1.0),
  ('JP.72030','2026-05-07',2474,2474,2433.1,2460.4,623112,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.72030','2026-05-08',2448.8,2453.4,2430.3,2451.5,686333,1.0),
  ('JP.72030','2026-05-11',2436.3,2462.7,2426.1,2447.8,577415,1.0),
  ('JP.72030','2026-05-12',2423.8,2457.5,2430.6,2438.3,601742,1.0),
  ('JP.72030','2026-05-13',2454.7,2461.9,2450,2454,724952,1.0),
  ('JP.72030','2026-05-14',2456.2,2446.3,2441.9,2445.5,824149,1.0),
  ('JP.72030','2026-05-15',2432.1,2470.4,2423,2441.9,697355,1.0),
  ('JP.72030','2026-05-18',2430.8,2453.1,2408.5,2434.9,729465,1.0),
  ('JP.72030','2026-05-19',2447.5,2454.5,2418.4,2435.6,937135,1.0),
  ('JP.72030','2026-05-20',2428.4,2441.8,2432.1,2441.5,941406,1.0),
  ('JP.72030','2026-05-21',2454.8,2467.5,2417.8,2446.5,876374,1.0),
  ('JP.72030','2026-05-22',2424.2,2447.2,2393.9,2421.6,917117,1.0),
  ('JP.72030','2026-05-25',2434.7,2478.1,2428,2449.1,991832,1.0),
  ('JP.72030','2026-05-26',2431.5,2447.1,2405.9,2427.9,1054124,1.0),
  ('JP.72030','2026-05-27',2452,2451.6,2431,2445.3,1037468,1.0),
  ('JP.72030','2026-05-28',2460.5,2450,2435,2446.8,1170671,1.0),
  ('JP.72030','2026-05-29',2444.8,2471,2428.8,2443.8,1156354,1.0),
  ('JP.72030','2026-06-01',2431.6,2452.4,2433.3,2436,1102350,1.0),
  ('JP.72030','2026-06-02',2415.3,2438.9,2422.3,2428.4,1220219,1.0),
  ('JP.72030','2026-06-03',2433.8,2457,2426,2447.8,1062775,1.0),
  ('JP.72030','2026-06-04',2446,2481.3,2444.2,2453,1099003,1.0),
  ('JP.72030','2026-06-05',2445.3,2456.3,2425,2451.4,1147545,1.0),
  ('JP.72030','2026-06-08',2444.4,2465.7,2448.9,2454.2,1187245,1.0),
  ('JP.72030','2026-06-09',2447.3,2470.3,2445.2,2452.3,1031287,1.0),
  ('JP.72030','2026-06-10',2451.4,2471.4,2440.5,2443.3,1071361,1.0),
  ('JP.72030','2026-06-11',2468.5,2485.2,2449.9,2457.4,1129644,1.0),
  ('JP.72030','2026-06-12',2479.7,2479.3,2453.9,2469,1074469,1.0),
  ('JP.72030','2026-06-15',2482,2473.1,2455.7,2468.7,984273,1.0),
  ('JP.72030','2026-06-16',2477.7,2468.3,2458,2463.1,825786,1.0),
  ('JP.72030','2026-06-17',2448.3,2480.8,2440.3,2462.4,791626,1.0),
  ('JP.72030','2026-06-18',2446.9,2482.4,2456.9,2461.5,732345,1.0),
  ('JP.72030','2026-06-19',2485.4,2502.7,2469.4,2482.1,748087,1.0),
  ('JP.72030','2026-06-22',2499.7,2504.4,2466.1,2491.8,744241,1.0),
  ('JP.72030','2026-06-23',2480.5,2507.2,2471.4,2482.7,637372,1.0),
  ('JP.72030','2026-06-24',2498.1,2499.2,2468.4,2496.9,663460,1.0),
  ('JP.72030','2026-06-25',2491.5,2515.4,2472.1,2490.7,753494,1.0),
  ('JP.72030','2026-06-26',2486.6,2503.8,2468.3,2489.9,712917,1.0),
  ('JP.72030','2026-06-29',2524.7,2535.2,2509.2,2521.5,646521,1.0),
  ('JP.72030','2026-06-30',2489.3,2505.7,2480.3,2503.7,719254,1.0),
  ('JP.72030','2026-07-01',2519.5,2543.3,2519.5,2522.4,611380,1.0),
  ('JP.72030','2026-07-02',2530.4,2551.7,2503.2,2522.6,732635,1.0),
  ('JP.72030','2026-07-03',2523.1,2548.9,2524.2,2529.5,724466,1.0),
  ('JP.72030','2026-07-06',2532.8,2548.7,2498.4,2524.9,771813,1.0),
  ('JP.72030','2026-07-07',2538,2573.8,2529.9,2551.4,681438,1.0),
  ('JP.72030','2026-07-08',2555.2,2564.6,2542,2554.5,705520,1.0),
  ('JP.72030','2026-07-09',2540.7,2547.9,2535.5,2545.5,714742,1.0),
  ('JP.72030','2026-07-10',2568.8,2588.1,2550.5,2571.4,824402,1.0),
  ('JP.72030','2026-07-13',2565.4,2587.3,2543.2,2558.5,983620,1.0),
  ('JP.72030','2026-07-14',2576.9,2590.9,2549.8,2576.9,883628,1.0),
  ('JP.72030','2026-07-15',2577.2,2588.5,2582.8,2586.3,1045134,1.0),
  ('JP.72030','2026-07-16',2600.6,2623.3,2578.5,2601.9,1067586,1.0),
  ('JP.72030','2026-07-17',2594,2596.7,2573.5,2582.8,1044639,1.0),
  ('JP.72030','2026-07-20',2584.1,2597.9,2568.7,2594.2,1107147,1.0),
  ('JP.72030','2026-07-21',2616.1,2632.5,2594.2,2612.3,1120520,1.0),
  ('JP.72030','2026-07-22',2631.9,2638.8,2597.8,2617.2,1029402,1.0),
  ('JP.72030','2026-07-23',2608.7,2636.6,2610.1,2618.6,1113544,1.0),
  ('JP.72030','2026-07-24',2613.3,2645.3,2598.1,2627.9,1201982,1.0),
  ('JP.72030','2026-07-27',2630,2660.4,2617.1,2644.2,1218257,1.0),
  ('JP.72030','2026-07-28',2635.5,2658.9,2611.3,2630.2,1211652,1.0),
  ('JP.72030','2026-07-29',2642.6,2670.7,2622.3,2652,1225002,1.0),
  ('JP.72030','2026-07-30',2638.8,2666.6,2625.3,2651.1,1152247,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.72030','2026-07-31',2637.7,2673.4,2619.5,2648.8,1088865,1.0),
  ('JP.72030','2026-08-03',2644.3,2677.7,2626.9,2657.5,1052684,1.0),
  ('JP.72030','2026-08-04',2672.2,2705.1,2676.3,2677.3,1038646,1.0),
  ('JP.72030','2026-08-05',2701.4,2706.1,2669.5,2687.3,914337,1.0),
  ('JP.72030','2026-08-06',2677.3,2709.1,2674,2689,917315,1.0),
  ('JP.72030','2026-08-07',2675.9,2690.8,2650.3,2681.3,910870,1.0),
  ('JP.72030','2026-08-10',2687.2,2689.7,2683.4,2684.4,837820,1.0),
  ('JP.72030','2026-08-11',2690.2,2686.8,2659.6,2680.8,795245,1.0),
  ('JP.72030','2026-08-12',2695.3,2696.1,2659.2,2682.4,757099,1.0),
  ('JP.72030','2026-08-13',2722.8,2713.3,2690.8,2712.2,820572,1.0),
  ('JP.72030','2026-08-14',2694.7,2708.3,2693.4,2703.2,729161,1.0),
  ('JP.72030','2026-08-17',2721.2,2728.7,2698.7,2705.5,776214,1.0),
  ('JP.72030','2026-08-18',2700.9,2739.7,2692.4,2708.2,607686,1.0),
  ('JP.72030','2026-08-19',2700.3,2747.6,2701.7,2716.4,630572,1.0),
  ('JP.72030','2026-08-20',2693.8,2725.3,2700.3,2707.5,742220,1.0),
  ('JP.72030','2026-08-21',2730.6,2735.5,2719.6,2730.4,619853,1.0),
  ('JP.72030','2026-08-24',2741.7,2759.5,2713.5,2734.1,562210,1.0),
  ('JP.72030','2026-08-25',2733.5,2748.4,2695.6,2723.1,590218,1.0),
  ('JP.72030','2026-08-26',2727.2,2749.2,2715.3,2738.7,782380,1.0),
  ('JP.72030','2026-08-27',2717.7,2740.1,2699.9,2724.5,651713,1.0);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-03',66.89,16.74,11,5.75,2519.94,2475.29,2491.16,2472.72,34.66,826093.15,0.877,0.031859,-0.004408,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-03','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-03','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-03','v1-technical',70,15,8,12,10,4,7,NULL,NULL,'BUY_WATCH',2529.5,2450.54,2633.48,1.317);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-06',64.63,17.3,12.26,5.05,2520.62,2478.85,2489.98,2472.99,35.78,805321.55,0.9584,0.028808,-0.004848,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-06','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-06','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-06','v1-technical',73,15,10,12,10,4,7,NULL,NULL,'BUY_WATCH',2524.9,2454.06,2632.23,1.515);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-07',70.76,19.66,13.74,5.92,2530.16,2483.77,2489.39,2473.46,36.71,787829.1,0.865,0.040411,0.011176,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-07','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-07','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-07','v1-technical',73,15,4,15,10,4,10,NULL,NULL,'BUY_WATCH',2551.4,2458.93,2661.54,1.191);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-08',71.39,21.53,15.3,6.23,2536.58,2488.04,2489,2473.98,35.71,769537.05,0.9168,0.045512,0.009644,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-08','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-08','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-08','v1-technical',73,15,4,15,10,4,10,NULL,NULL,'BUY_WATCH',2554.5,2463.16,2661.62,1.173);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-09',66.92,22.03,16.64,5.39,2541.16,2491.74,2488.61,2474.39,34.51,748791.95,0.9545,0.035851,0.0106,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-09','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-09','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-09','v1-technical',80,15,8,12,15,4,10,NULL,NULL,'BUY_WATCH',2545.5,2466.82,2649.04,1.316);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-10',72.29,24.23,18.16,6.07,2549.54,2496.54,2488.45,2475.07,35.09,736288.6,1.1197,0.041474,0.019103,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-10','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-10','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-10','v1-technical',79,15,4,15,15,4,10,NULL,NULL,'BUY_WATCH',2571.4,2501.22,2676.67,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-13',66.5,24.66,19.46,5.2,2556.26,2500.71,2488.27,2475.66,35.73,736255.95,1.336,0.036375,0.024096,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-13','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-13','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-13','v1-technical',85,15,8,12,15,8,10,NULL,NULL,'BUY_NOW',2558.5,2475.7,2665.7,1.295);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-14',70.17,26.18,20.8,5.37,2561.36,2505.69,2488.43,2476.42,36.12,739148.05,1.1955,0.046202,0.02327,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-14','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-14','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-14','v1-technical',85,20,4,15,15,4,10,NULL,NULL,'BUY_WATCH',2576.9,2480.64,2685.25,1.126);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-15',71.87,27.82,22.21,5.61,2567.72,2511.41,2488.77,2477.12,34.37,751823.45,1.3901,0.050317,0.036344,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-15','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-15','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-15','v1-technical',90,20,4,15,15,8,10,NULL,NULL,'BUY_WATCH',2586.3,2517.57,2689.4,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-16',74.47,30.03,23.77,6.26,2579,2517.19,2489.41,2478.04,35.11,768585.5,1.389,0.057038,0.047042,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-16','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-16','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-16','v1-technical',90,20,4,15,15,8,10,NULL,NULL,'BUY_WATCH',2601.9,2531.68,2707.24,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-17',66.39,29.9,25,4.9,2581.28,2521.74,2489.73,2478.81,34.63,783413.1,1.3334,0.04057,0.032253,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-17','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-17','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-17','v1-technical',91,20,8,12,15,8,10,NULL,NULL,'BUY_NOW',2582.8,2496.53,2686.7,1.204);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-20',68.58,30.37,26.07,4.3,2588.42,2526.76,2490.06,2479.66,34.24,801558.4,1.3812,0.041095,0.048712,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-20','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-20','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-20','v1-technical',91,20,8,12,15,8,10,NULL,NULL,'BUY_WATCH',2594.2,2501.5,2696.93,1.108);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-21',71.73,31.83,27.22,4.61,2595.5,2532.73,2490.75,2480.72,34.53,825715.8,1.357,0.052201,0.056243,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-21','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-21','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-21','v1-technical',90,20,4,15,15,8,10,NULL,NULL,'BUY_WATCH',2612.3,2543.23,2715.9,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-22',72.53,33,28.38,4.62,2601.68,2538.92,2491.72,2481.72,35,844012.9,1.2197,0.04818,0.055961,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-22','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-22','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-22','v1-technical',90,20,4,15,15,8,10,NULL,NULL,'BUY_WATCH',2617.2,2547.21,2722.19,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-23',72.77,33.66,29.44,4.22,2605.02,2545.21,2492.7,2482.73,34.39,862015.4,1.2918,0.051351,0.055249,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-23','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-23','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-23','v1-technical',86,20,4,12,15,8,10,NULL,NULL,'BUY_WATCH',2618.6,2549.82,2721.77,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-24',74.36,34.53,30.45,4.08,2614.04,2551.04,2493.86,2483.82,35.3,886468.65,1.3559,0.055424,0.05921,2634.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-24','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-24','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-24','v1-technical',86,20,4,12,15,8,10,NULL,NULL,'BUY_WATCH',2627.9,2557.29,2733.81,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-27',76.9,36.12,31.59,4.53,2624.04,2557.14,2495.29,2485.08,35.88,915055.45,1.3313,0.048662,0.075709,2644.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-27','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-27','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-27','v1-technical',90,20,4,15,15,8,10,NULL,NULL,'BUY_WATCH',2644.2,2572.45,2751.83,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-28',70.44,35.84,32.44,3.4,2627.62,2563.04,2496.71,2486.33,36.71,939675.35,1.2894,0.050525,0.062021,2644.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-28','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-28','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-28','v1-technical',86,20,4,12,15,8,10,NULL,NULL,'BUY_WATCH',2630.2,2537.41,2740.34,1.187);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-29',74.09,36.95,33.34,3.61,2634.58,2569.24,2498.34,2487.68,37.55,970356.45,1.2624,0.05138,0.08413,2652,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-29','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-29','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-29','v1-technical',90,20,4,15,15,8,10,NULL,NULL,'BUY_WATCH',2652,2576.91,2764.64,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-30',73.69,37.32,34.14,3.19,2641.08,2575.66,2500.1,2489.01,37.82,991337.05,1.1623,0.05094,0.077508,2652,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-30','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-30','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-30','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',2651.1,2549.9,2764.55,1.121);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-07-31',72.59,37.01,34.71,2.3,2645.26,2582.01,2501.78,2490.4,38.96,1009557,1.0786,0.047163,0.080481,2652,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-31','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-07-31','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-07-31','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',2648.8,2556.19,2765.69,1.262);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-03',74.15,37.03,35.18,1.86,2647.92,2587.45,2503.9,2491.78,39.81,1023600.55,1.0284,0.052517,0.085669,2657.5,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-03','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-03','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-03','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',2657.5,2561.58,2776.93,1.245);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-04',77.32,38.21,35.78,2.43,2657.34,2594.4,2506.02,2493.38,40.37,1041460.95,0.9973,0.049345,0.098019,2677.3,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-04','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-04','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-04','v1-technical',85,20,4,15,15,4,10,NULL,NULL,'BUY_WATCH',2677.3,2596.57,2798.4,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-05',78.73,39.5,36.53,2.97,2664.4,2600.99,2508.58,2495.02,40.1,1051901.8,0.8692,0.051987,0.095069,2687.3,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-05','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-05','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-05','v1-technical',85,20,4,15,15,4,10,NULL,NULL,'BUY_WATCH',2687.3,2607.11,2807.59,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-06',78.97,40.19,37.26,2.93,2671.98,2607.65,2511.3,2496.67,39.74,1062030.45,0.8637,0.056374,0.099571,2689,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-06','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-06','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-06','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',2689,2609.52,2808.22,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-07',74.85,39.66,37.74,1.92,2678.48,2613.72,2513.69,2498.26,39.79,1066353.85,0.8542,0.042739,0.098038,2689,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-07','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-07','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-07','v1-technical',81,20,4,12,15,4,10,NULL,NULL,'BUY_WATCH',2681.3,2587.58,2800.68,1.274);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-10',75.41,39.04,38,1.04,2683.86,2620.1,2516.5,2499.95,37.55,1059063.85,0.7911,0.049209,0.102468,2689,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-10','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-10','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-10','v1-technical',78,20,4,12,15,1,10,NULL,NULL,'BUY_WATCH',2684.4,2593.9,2797.06,1.245);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-11',73.37,37.82,37.96,-0.14,2684.56,2625.28,2519.26,2501.64,36.81,1054644.7,0.754,0.04032,0.100673,2689,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-11','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-11','exit',1,'{"met":["macd_dead_cross"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-11','v1-technical',65,20,4,2,15,1,10,NULL,NULL,'BUY_WATCH',2680.8,2599.02,2791.24,1.35);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-12',73.71,36.57,37.68,-1.12,2683.58,2630.39,2521.98,2503.31,36.82,1040242.95,0.7278,0.037157,0.098669,2689,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-12','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-12','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-12','v1-technical',63,20,4,2,13,1,10,NULL,NULL,'BUY_WATCH',2682.4,2604.09,2792.86,1.41);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-13',79.06,37.54,37.66,-0.11,2688.22,2637.06,2525.06,2505.12,36.4,1027892.25,0.7983,0.042392,0.108604,2712.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-13','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-13','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-13','v1-technical',69,20,4,5,15,1,10,NULL,NULL,'BUY_WATCH',2712.2,2639.41,2821.39,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-14',74.15,37.16,37.56,-0.4,2692.6,2642.33,2528.02,2506.88,35.14,1012118.35,0.7204,0.046616,0.116287,2712.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-14','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-14','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-14','v1-technical',65,20,4,2,15,1,10,NULL,NULL,'BUY_WATCH',2703.2,2615.91,2808.62,1.208);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-17',74.59,36.62,37.37,-0.75,2696.82,2648.21,2531.32,2508.71,34.77,995571.7,0.7797,0.042903,0.104692,2712.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-17','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-17','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-17','v1-technical',65,20,4,2,15,1,10,NULL,NULL,'BUY_WATCH',2705.5,2621.73,2809.82,1.245);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-18',75.12,36,37.09,-1.1,2702.3,2653.46,2534.41,2510.53,35.67,969930,0.6265,0.036711,0.11545,2712.2,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-18','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-18','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-18','v1-technical',65,20,4,2,15,1,10,NULL,NULL,'BUY_WATCH',2708.2,2626.93,2815.2,1.317);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-19',76.7,35.75,36.83,-1.07,2709.1,2658.67,2538.01,2512.46,36.4,949988.5,0.6638,0.037903,0.110866,2716.4,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-19','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-19','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-19','v1-technical',69,20,4,5,15,1,10,NULL,NULL,'BUY_WATCH',2716.4,2632.08,2825.59,1.295);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-20',71.39,34.44,36.35,-1.91,2708.16,2662.89,2541.31,2514.36,35.58,931422.3,0.7969,0.033949,0.106547,2716.4,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-20','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-20','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-20','v1-technical',63,20,4,2,13,1,10,NULL,NULL,'BUY_WATCH',2707.5,2636.26,2814.25,1.499);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-21',76,34.85,36.05,-1.2,2713.6,2668.8,2545.02,2516.39,35.04,902315.85,0.687,0.039005,0.117276,2730.4,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-21','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-21','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-21','v1-technical',69,20,4,5,15,1,10,NULL,NULL,'BUY_WATCH',2730.4,2642.11,2835.53,1.191);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-24',76.65,35.07,35.85,-0.79,2719.32,2674.39,2548.84,2518.42,35.82,869513.5,0.6466,0.033999,0.122373,2734.1,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-24','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-24','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-24','v1-technical',69,20,4,5,15,1,10,NULL,NULL,'BUY_WATCH',2734.1,2647.65,2841.57,1.243);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-25',70.5,33.96,35.47,-1.51,2722.3,2678.82,2552.64,2520.42,37.04,838441.8,0.7039,0.035321,0.121356,2734.1,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-25','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-25','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-25','v1-technical',65,20,4,2,15,1,10,NULL,NULL,'BUY_WATCH',2723.1,2652.04,2834.21,1.564);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-26',73.72,33.95,35.17,-1.22,2726.76,2683.68,2556.43,2522.47,36.81,816310.7,0.9584,0.032692,0.118841,2738.7,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-26','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-26','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-26','v1-technical',73,20,4,5,15,4,10,NULL,NULL,'BUY_WATCH',2738.7,2656.85,2849.14,1.349);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.72030','2026-08-27',66.59,32.43,34.62,-2.2,2730.16,2687.92,2560.15,2524.47,37.06,791284,0.8236,0.027687,0.110681,2738.7,2317.2);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-27','golden_cross',5,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.72030','2026-08-27','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.72030','2026-08-27','v1-technical',74,20,8,2,15,4,10,NULL,NULL,'BUY_WATCH',2724.5,2661.04,2835.67,1.752);

INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.99840','2025-08-29',5729.3,5722.8,5644.4,5710.1,919024,1.0),
  ('JP.99840','2025-09-01',5772.2,5754.8,5726.5,5748.1,900146,1.0),
  ('JP.99840','2025-09-02',5736.8,5752.1,5745.2,5749.6,1009029,1.0),
  ('JP.99840','2025-09-03',5768.5,5789.6,5728.1,5759.6,1043207,1.0),
  ('JP.99840','2025-09-04',5775.7,5816.3,5710.9,5767.6,1042524,1.0),
  ('JP.99840','2025-09-05',5783.6,5780,5720.3,5763.9,1001425,1.0),
  ('JP.99840','2025-09-08',5793.9,5872.5,5796.1,5808.3,1067467,1.0),
  ('JP.99840','2025-09-09',5762.1,5783.1,5737.6,5756.8,1042231,1.0),
  ('JP.99840','2025-09-10',5814.4,5798.7,5738.3,5780,1063329,1.0),
  ('JP.99840','2025-09-11',5802.6,5807.6,5760.2,5784.3,1130718,1.0),
  ('JP.99840','2025-09-12',5811.2,5814.5,5746.5,5789.4,1128009,1.0),
  ('JP.99840','2025-09-15',5798.4,5851.1,5728.9,5789.9,1107535,1.0),
  ('JP.99840','2025-09-16',5817.1,5868.2,5794,5819.6,1075845,1.0),
  ('JP.99840','2025-09-17',5812.3,5833.1,5783.8,5832.4,1131067,1.0),
  ('JP.99840','2025-09-18',5835.3,5845.8,5810.9,5818.8,1023473,1.0),
  ('JP.99840','2025-09-19',5824.8,5845.1,5790.4,5812.2,1074617,1.0),
  ('JP.99840','2025-09-22',5828.2,5920.7,5813.4,5854.3,1052982,1.0),
  ('JP.99840','2025-09-23',5820.9,5916.1,5802.8,5849.5,1050018,1.0),
  ('JP.99840','2025-09-24',5830.2,5893.9,5818.5,5833,943654,1.0),
  ('JP.99840','2025-09-25',5831.1,5852.9,5789.8,5843,892601,1.0),
  ('JP.99840','2025-09-26',5883.2,5918.2,5859.7,5875.8,866881,1.0),
  ('JP.99840','2025-09-29',5830.4,5883.3,5843.3,5845.9,851280,1.0),
  ('JP.99840','2025-09-30',5857.8,5919.7,5846.4,5888.9,756306,1.0),
  ('JP.99840','2025-10-01',5867.7,5845,5803.5,5843,744129,1.0),
  ('JP.99840','2025-10-02',5832.6,5927.3,5826.2,5864.6,809170,1.0),
  ('JP.99840','2025-10-03',5876.9,5888.6,5841.6,5860.2,626741,1.0),
  ('JP.99840','2025-10-06',5900.8,5924,5819.1,5873.8,757862,1.0),
  ('JP.99840','2025-10-07',5856.7,5908.9,5817.7,5882,640422,1.0),
  ('JP.99840','2025-10-08',5848.3,5899.9,5795.6,5832.8,585251,1.0),
  ('JP.99840','2025-10-09',5848.3,5867.5,5823.2,5843,722247,1.0),
  ('JP.99840','2025-10-10',5873.8,5859.7,5828.2,5839.4,755962,1.0),
  ('JP.99840','2025-10-13',5881.2,5871.4,5797.5,5853.6,731873,1.0),
  ('JP.99840','2025-10-14',5857.3,5888.1,5822.5,5864.6,610962,1.0),
  ('JP.99840','2025-10-15',5820.6,5818.3,5763.9,5804.1,643127,1.0),
  ('JP.99840','2025-10-16',5849.6,5915.1,5822.4,5847.9,837012,1.0),
  ('JP.99840','2025-10-17',5803.4,5870.6,5799.7,5819.9,824316,1.0),
  ('JP.99840','2025-10-20',5823.4,5882.9,5823.7,5825.1,888351,1.0),
  ('JP.99840','2025-10-21',5865.7,5878.5,5830.1,5837.3,852469,1.0),
  ('JP.99840','2025-10-22',5805.7,5781.7,5761.4,5779.1,817806,1.0),
  ('JP.99840','2025-10-23',5831.8,5850.9,5788.9,5804,1035791,1.0),
  ('JP.99840','2025-10-24',5778.7,5784.8,5762,5766.8,980949,1.0),
  ('JP.99840','2025-10-27',5816.1,5835.7,5729.3,5788.1,1017990,1.0),
  ('JP.99840','2025-10-28',5757.1,5832.4,5709.6,5770.4,1022412,1.0),
  ('JP.99840','2025-10-29',5712.9,5767.4,5687.9,5745.4,1170352,1.0),
  ('JP.99840','2025-10-30',5739.1,5781.9,5661.1,5728.2,1050511,1.0),
  ('JP.99840','2025-10-31',5700.8,5719.7,5681.7,5691.5,1104978,1.0),
  ('JP.99840','2025-11-03',5668.7,5753.5,5654.2,5687.4,1067490,1.0),
  ('JP.99840','2025-11-04',5645.1,5685,5672.7,5677.3,1227952,1.0),
  ('JP.99840','2025-11-05',5751.9,5767.9,5713.8,5720.6,1160384,1.0),
  ('JP.99840','2025-11-06',5696.5,5747.7,5699.2,5704.4,1156878,1.0),
  ('JP.99840','2025-11-07',5673.1,5733.2,5659.7,5673.6,1184306,1.0),
  ('JP.99840','2025-11-10',5674,5712.9,5640.3,5665.4,1115774,1.0),
  ('JP.99840','2025-11-11',5607.3,5704.4,5573.7,5638.8,1098278,1.0),
  ('JP.99840','2025-11-12',5648.8,5636.7,5583.2,5616.5,1054074,1.0),
  ('JP.99840','2025-11-13',5597,5637.5,5601.4,5607.4,1056187,1.0),
  ('JP.99840','2025-11-14',5615.5,5667.2,5579.6,5602,878174,1.0),
  ('JP.99840','2025-11-17',5577.8,5588.3,5585.2,5587.2,824398,1.0),
  ('JP.99840','2025-11-18',5566.8,5635.3,5552.2,5588.7,795880,1.0),
  ('JP.99840','2025-11-19',5563.4,5597.4,5508.2,5548.3,805615,1.0),
  ('JP.99840','2025-11-20',5555.3,5602.6,5531.9,5569.5,818905,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.99840','2025-11-21',5544.7,5535,5495.5,5520,708156,1.0),
  ('JP.99840','2025-11-24',5463,5487.9,5432.9,5480.9,708557,1.0),
  ('JP.99840','2025-11-25',5490.4,5528.5,5454.5,5504,623485,1.0),
  ('JP.99840','2025-11-26',5474.7,5544.2,5459.2,5490.1,747715,1.0),
  ('JP.99840','2025-11-27',5435.1,5485.7,5419,5458.6,575015,1.0),
  ('JP.99840','2025-11-28',5463.5,5501.7,5403.1,5460.2,640249,1.0),
  ('JP.99840','2025-12-01',5408.5,5474.4,5395.5,5423.6,590461,1.0),
  ('JP.99840','2025-12-02',5440.2,5442.1,5352.4,5414.6,640090,1.0),
  ('JP.99840','2025-12-03',5397.2,5436.8,5369.3,5419.5,640812,1.0),
  ('JP.99840','2025-12-04',5444.4,5481.5,5384.6,5418.3,658364,1.0),
  ('JP.99840','2025-12-05',5424.5,5407.9,5349.6,5396.8,693861,1.0),
  ('JP.99840','2025-12-08',5373.6,5422.3,5387.6,5401.6,651090,1.0),
  ('JP.99840','2025-12-09',5343,5360,5278,5341.7,861623,1.0),
  ('JP.99840','2025-12-10',5383.5,5408.8,5343.2,5385.7,814330,1.0),
  ('JP.99840','2025-12-11',5377.9,5402.9,5371.3,5383.3,891459,1.0),
  ('JP.99840','2025-12-12',5336,5404.5,5362.4,5365.7,870861,1.0),
  ('JP.99840','2025-12-15',5323.6,5382.1,5317,5323.8,872736,1.0),
  ('JP.99840','2025-12-16',5335.9,5313.8,5262.7,5312.8,984936,1.0),
  ('JP.99840','2025-12-17',5272.9,5318.7,5274.5,5294,917000,1.0),
  ('JP.99840','2025-12-18',5321.4,5318.6,5261.9,5291.6,1052044,1.0),
  ('JP.99840','2025-12-19',5261.9,5333.2,5243.2,5282.5,1132262,1.0),
  ('JP.99840','2025-12-22',5316.6,5344.8,5251,5294.1,1041229,1.0),
  ('JP.99840','2025-12-23',5292.6,5363.3,5264.3,5317.6,1163780,1.0),
  ('JP.99840','2025-12-24',5285,5296,5255.4,5284.4,1180975,1.0),
  ('JP.99840','2025-12-25',5264.7,5277.3,5209.2,5251,1127049,1.0),
  ('JP.99840','2025-12-26',5236.4,5300.7,5218.7,5246.4,1238515,1.0),
  ('JP.99840','2025-12-29',5262.9,5317,5232.4,5265.9,1226075,1.0),
  ('JP.99840','2025-12-30',5271.1,5341.5,5269.9,5282.4,1208976,1.0),
  ('JP.99840','2025-12-31',5255.5,5290.1,5209.5,5260.1,1144012,1.0),
  ('JP.99840','2026-01-01',5308.7,5319.9,5242.8,5283.7,1167786,1.0),
  ('JP.99840','2026-01-02',5298.4,5296.8,5253,5284.1,1126275,1.0),
  ('JP.99840','2026-01-05',5262.9,5298.6,5273.8,5280.6,1109474,1.0),
  ('JP.99840','2026-01-06',5225,5299.9,5193.2,5248,960837,1.0),
  ('JP.99840','2026-01-07',5322.8,5357.5,5253.7,5296.2,861097,1.0),
  ('JP.99840','2026-01-08',5246,5263.9,5236.3,5253.8,909088,1.0),
  ('JP.99840','2026-01-09',5242.2,5271.6,5222.7,5251.7,881426,1.0),
  ('JP.99840','2026-01-12',5228.6,5305.3,5239.9,5252.9,865888,1.0),
  ('JP.99840','2026-01-13',5260,5308.8,5245.6,5278.9,700166,1.0),
  ('JP.99840','2026-01-14',5241.8,5328.6,5246.4,5269.3,741678,1.0),
  ('JP.99840','2026-01-15',5316.5,5327.4,5277.9,5311.8,777553,1.0),
  ('JP.99840','2026-01-16',5293.1,5316.4,5232.6,5291.1,675409,1.0),
  ('JP.99840','2026-01-19',5281.4,5333.3,5235.7,5285.7,635891,1.0),
  ('JP.99840','2026-01-20',5288.2,5310.7,5246.7,5287.3,716864,1.0),
  ('JP.99840','2026-01-21',5313.9,5339.3,5254.6,5282.7,693750,1.0),
  ('JP.99840','2026-01-22',5321.7,5350.4,5336.2,5344,673444,1.0),
  ('JP.99840','2026-01-23',5342,5362.1,5285.5,5313,682912,1.0),
  ('JP.99840','2026-01-26',5358.4,5415.3,5353.6,5357.4,611949,1.0),
  ('JP.99840','2026-01-27',5359.9,5387.5,5362.1,5375,710359,1.0),
  ('JP.99840','2026-01-28',5379.4,5368.3,5348,5360.1,652901,1.0),
  ('JP.99840','2026-01-29',5385.6,5401.6,5322,5364.5,705100,1.0),
  ('JP.99840','2026-01-30',5367,5395.7,5331.6,5370.7,706118,1.0),
  ('JP.99840','2026-02-02',5341.3,5381,5324.8,5362.6,824966,1.0),
  ('JP.99840','2026-02-03',5412.3,5394.2,5359.4,5394,883826,1.0),
  ('JP.99840','2026-02-04',5461.1,5451.4,5426.2,5430.4,954102,1.0),
  ('JP.99840','2026-02-05',5429,5448.3,5423.3,5434.6,1004398,1.0),
  ('JP.99840','2026-02-06',5419.6,5477.5,5358.3,5417.8,960357,1.0),
  ('JP.99840','2026-02-09',5403.3,5434.2,5386.6,5416.7,1078033,1.0),
  ('JP.99840','2026-02-10',5496.5,5499.6,5422.9,5466.9,1065523,1.0),
  ('JP.99840','2026-02-11',5468.7,5478.4,5436.4,5440.8,1058114,1.0),
  ('JP.99840','2026-02-12',5472.6,5487.3,5422.5,5473.1,1172964,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.99840','2026-02-13',5493.2,5531.6,5491.2,5492.7,1060863,1.0),
  ('JP.99840','2026-02-16',5488.9,5507.4,5427.6,5475.2,1059100,1.0),
  ('JP.99840','2026-02-17',5509,5506,5490.5,5502.9,1213983,1.0),
  ('JP.99840','2026-02-18',5526.7,5511.2,5488.6,5507.1,1229939,1.0),
  ('JP.99840','2026-02-19',5578.8,5620.7,5555.1,5555.3,1104517,1.0),
  ('JP.99840','2026-02-20',5517.1,5588.7,5514.5,5532.7,1133913,1.0),
  ('JP.99840','2026-02-23',5521,5575.8,5524.2,5532.6,1169834,1.0),
  ('JP.99840','2026-02-24',5596.2,5641.6,5565,5601.7,1170155,1.0),
  ('JP.99840','2026-02-25',5588.7,5583.5,5544,5574.6,1125894,1.0),
  ('JP.99840','2026-02-26',5554.8,5633.6,5514.9,5574.2,1099567,1.0),
  ('JP.99840','2026-02-27',5568.2,5603.7,5547.4,5594.8,966204,1.0),
  ('JP.99840','2026-03-02',5672.4,5691.1,5634,5649.2,917016,1.0),
  ('JP.99840','2026-03-03',5655.8,5722.2,5628.1,5654.8,805766,1.0),
  ('JP.99840','2026-03-04',5681.8,5722.5,5674.6,5680.7,939345,1.0),
  ('JP.99840','2026-03-05',5656,5692.7,5629.7,5679.7,799209,1.0),
  ('JP.99840','2026-03-06',5695,5735.9,5642.2,5673.2,867996,1.0),
  ('JP.99840','2026-03-09',5709.9,5684.3,5641.6,5677.5,743788,1.0),
  ('JP.99840','2026-03-10',5733.3,5763.7,5678,5700.5,659480,1.0),
  ('JP.99840','2026-03-11',5670,5746.3,5627.2,5693.8,698420,1.0),
  ('JP.99840','2026-03-12',5719.4,5784.5,5692.2,5732.6,644169,1.0),
  ('JP.99840','2026-03-13',5770.9,5765.3,5725.4,5741,622026,1.0),
  ('JP.99840','2026-03-16',5721.1,5779.5,5693.3,5732.7,636396,1.0),
  ('JP.99840','2026-03-17',5776.4,5801.6,5709.4,5752.1,570562,1.0),
  ('JP.99840','2026-03-18',5704.6,5739.7,5710.7,5738,639204,1.0),
  ('JP.99840','2026-03-19',5740.3,5781.6,5765.6,5769.9,604778,1.0),
  ('JP.99840','2026-03-20',5748.9,5738.5,5670.1,5727.6,727726,1.0),
  ('JP.99840','2026-03-23',5770.5,5822.9,5740.8,5792.3,762492,1.0),
  ('JP.99840','2026-03-24',5807.7,5857.8,5739.3,5793.1,658577,1.0),
  ('JP.99840','2026-03-25',5777.9,5797.4,5740.8,5780.8,852441,1.0),
  ('JP.99840','2026-03-26',5783.6,5821.8,5748.6,5765.6,861460,1.0),
  ('JP.99840','2026-03-27',5785.8,5791.1,5731.3,5769.1,944109,1.0),
  ('JP.99840','2026-03-30',5792.8,5817.2,5808,5811.7,985693,1.0),
  ('JP.99840','2026-03-31',5826.3,5838.3,5802.9,5815.5,871870,1.0),
  ('JP.99840','2026-04-01',5776.7,5808.4,5743,5774.5,1061281,1.0),
  ('JP.99840','2026-04-02',5799.7,5889.1,5792.3,5820,954731,1.0),
  ('JP.99840','2026-04-03',5821.9,5820.8,5764.9,5797.1,1053846,1.0),
  ('JP.99840','2026-04-06',5812.5,5841.1,5762.3,5783.9,1067536,1.0),
  ('JP.99840','2026-04-07',5828,5845.5,5777.4,5811,1107782,1.0),
  ('JP.99840','2026-04-08',5788,5871.5,5750.6,5811.9,1098126,1.0),
  ('JP.99840','2026-04-09',5767.1,5834.6,5741.6,5768.3,1144808,1.0),
  ('JP.99840','2026-04-10',5818.4,5810.4,5793,5809.8,1100124,1.0),
  ('JP.99840','2026-04-13',5778.1,5772.6,5741.9,5763.9,1078325,1.0),
  ('JP.99840','2026-04-14',5759.7,5799.7,5744.9,5776.9,1215326,1.0),
  ('JP.99840','2026-04-15',5761.7,5792.5,5719.7,5746.3,1179933,1.0),
  ('JP.99840','2026-04-16',5709.9,5753.6,5726.1,5739.3,1105492,1.0),
  ('JP.99840','2026-04-17',5778.7,5816.8,5716.6,5776.5,1055826,1.0),
  ('JP.99840','2026-04-20',5757.9,5788.5,5707.7,5739.1,1113280,1.0),
  ('JP.99840','2026-04-21',5788.1,5819.6,5744.5,5758.3,919887,1.0),
  ('JP.99840','2026-04-22',5697.1,5740.1,5676.2,5718.2,878529,1.0),
  ('JP.99840','2026-04-23',5723.3,5766.8,5737.6,5739.8,949775,1.0),
  ('JP.99840','2026-04-24',5704.5,5787.4,5711.2,5735.9,981640,1.0),
  ('JP.99840','2026-04-27',5719.9,5713.3,5691.7,5702.9,744562,1.0),
  ('JP.99840','2026-04-28',5744.8,5751.5,5668.1,5723.4,782915,1.0),
  ('JP.99840','2026-04-29',5624.4,5707,5650,5656.6,830008,1.0),
  ('JP.99840','2026-04-30',5685,5721,5657.6,5711,687854,1.0),
  ('JP.99840','2026-05-01',5681.8,5701.2,5621.2,5672.4,642977,1.0),
  ('JP.99840','2026-05-04',5662.3,5673.7,5636.1,5653,606136,1.0),
  ('JP.99840','2026-05-05',5638.3,5691.9,5626.6,5668.5,632117,1.0),
  ('JP.99840','2026-05-06',5671.7,5697.7,5611.4,5646.4,698734,1.0),
  ('JP.99840','2026-05-07',5604.3,5663.1,5585.6,5599.4,700448,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.99840','2026-05-08',5604.4,5603.5,5554.9,5574.7,635952,1.0),
  ('JP.99840','2026-05-11',5599.1,5677.8,5594.7,5627.9,749211,1.0),
  ('JP.99840','2026-05-12',5561.5,5583.7,5541,5575.7,631512,1.0),
  ('JP.99840','2026-05-13',5618.2,5648.3,5570.1,5599.5,623956,1.0),
  ('JP.99840','2026-05-14',5565.2,5569.8,5544.1,5550.3,686739,1.0),
  ('JP.99840','2026-05-15',5520.2,5540.1,5526.3,5527.8,675704,1.0),
  ('JP.99840','2026-05-18',5554.2,5579.1,5494.4,5545.5,886861,1.0),
  ('JP.99840','2026-05-19',5486.8,5560.6,5460.4,5505,894698,1.0),
  ('JP.99840','2026-05-20',5496.1,5503.4,5419,5479.4,850971,1.0),
  ('JP.99840','2026-05-21',5507.4,5527.7,5494.9,5494.9,914294,1.0),
  ('JP.99840','2026-05-22',5488,5520.3,5446.5,5467.9,1060815,1.0),
  ('JP.99840','2026-05-25',5451.8,5476.8,5430.6,5465.8,980319,1.0),
  ('JP.99840','2026-05-26',5442.4,5438.8,5402.7,5420.2,993717,1.0),
  ('JP.99840','2026-05-27',5412.6,5449.9,5404.1,5417.1,999424,1.0),
  ('JP.99840','2026-05-28',5406,5485.7,5430.6,5436,1074213,1.0),
  ('JP.99840','2026-05-29',5423.7,5424,5375.8,5409,1080870,1.0),
  ('JP.99840','2026-06-01',5365.9,5422.5,5358.9,5384.3,1049775,1.0),
  ('JP.99840','2026-06-02',5344.9,5363.2,5310.2,5363.1,1132520,1.0),
  ('JP.99840','2026-06-03',5350.9,5370.7,5274.7,5336.2,1200901,1.0),
  ('JP.99840','2026-06-04',5359.8,5345.8,5330.4,5331.4,1125905,1.0),
  ('JP.99840','2026-06-05',5387.4,5395.8,5360.8,5367.7,1227308,1.0),
  ('JP.99840','2026-06-08',5359.9,5372.9,5304.5,5351.6,1169679,1.0),
  ('JP.99840','2026-06-09',5276.4,5332,5265.4,5303,1022509,1.0),
  ('JP.99840','2026-06-10',5304.7,5355.9,5293.7,5326.9,988030,1.0),
  ('JP.99840','2026-06-11',5345.7,5321,5315.2,5320.6,1071159,1.0),
  ('JP.99840','2026-06-12',5255.8,5260.6,5224.3,5260.3,953198,1.0),
  ('JP.99840','2026-06-15',5305.7,5309.7,5234.4,5280.6,989708,1.0),
  ('JP.99840','2026-06-16',5298,5318,5247.3,5272.7,931637,1.0),
  ('JP.99840','2026-06-17',5237,5281,5184.5,5245.7,793668,1.0),
  ('JP.99840','2026-06-18',5247.7,5341.9,5276.7,5279.3,834043,1.0),
  ('JP.99840','2026-06-19',5274.6,5317.5,5209.7,5268.5,726532,1.0),
  ('JP.99840','2026-06-22',5236,5285.6,5226.9,5260,772991,1.0),
  ('JP.99840','2026-06-23',5230.9,5249.6,5166.5,5228.5,738780,1.0),
  ('JP.99840','2026-06-24',5250.7,5280.8,5183.9,5246.8,690704,1.0),
  ('JP.99840','2026-06-25',5215.1,5259.1,5207.7,5222.6,672754,1.0),
  ('JP.99840','2026-06-26',5190.8,5203.1,5138.9,5183.1,686101,1.0),
  ('JP.99840','2026-06-29',5212.6,5267.2,5164.5,5221.2,703148,1.0),
  ('JP.99840','2026-06-30',5180.1,5233.8,5177.8,5185.9,607165,1.0),
  ('JP.99840','2026-07-01',5187.4,5266,5156.5,5213.5,715848,1.0),
  ('JP.99840','2026-07-02',5221.4,5238.5,5172.2,5208.3,644371,1.0),
  ('JP.99840','2026-07-03',5213.4,5254.2,5189.3,5222.2,692388,1.0),
  ('JP.99840','2026-07-06',5200.5,5229.1,5194.5,5213.1,625947,1.0),
  ('JP.99840','2026-07-07',5161.4,5217.1,5155.9,5184.4,715920,1.0),
  ('JP.99840','2026-07-08',5156.3,5195.1,5140.8,5168.1,738524,1.0),
  ('JP.99840','2026-07-09',5178.6,5227.3,5164.3,5169.3,739707,1.0),
  ('JP.99840','2026-07-10',5169.2,5181.4,5097.8,5154.9,839890,1.0),
  ('JP.99840','2026-07-13',5221.9,5268.8,5180.8,5210.8,873418,1.0),
  ('JP.99840','2026-07-14',5194.9,5225.6,5159.2,5173.6,856481,1.0),
  ('JP.99840','2026-07-15',5253.6,5227.7,5212.4,5222.3,1058263,1.0),
  ('JP.99840','2026-07-16',5178.5,5202.1,5109.9,5168,929524,1.0),
  ('JP.99840','2026-07-17',5188.1,5217.1,5163.3,5169.6,1131874,1.0),
  ('JP.99840','2026-07-20',5200.9,5208.2,5148.6,5188,1052810,1.0),
  ('JP.99840','2026-07-21',5188.3,5229,5176.9,5181.3,1040268,1.0),
  ('JP.99840','2026-07-22',5216.2,5276.2,5237.3,5246.4,1094495,1.0),
  ('JP.99840','2026-07-23',5212.3,5239.5,5222.8,5223,1049738,1.0),
  ('JP.99840','2026-07-24',5188.9,5274.1,5160.1,5215.6,1177559,1.0),
  ('JP.99840','2026-07-27',5210.6,5276.9,5179.6,5230.3,1058607,1.0),
  ('JP.99840','2026-07-28',5306.4,5314.4,5274.3,5280.3,1171098,1.0),
  ('JP.99840','2026-07-29',5266.4,5279.8,5231.4,5250.9,1219904,1.0),
  ('JP.99840','2026-07-30',5287.2,5331.6,5231.2,5293.9,1180007,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.99840','2026-07-31',5300,5318.7,5245.1,5304.4,1073788,1.0),
  ('JP.99840','2026-08-03',5267.7,5282,5216.4,5264.4,976322,1.0),
  ('JP.99840','2026-08-04',5255,5300.8,5222.3,5277.2,965310,1.0),
  ('JP.99840','2026-08-05',5317.6,5324.3,5284.8,5296.5,953973,1.0),
  ('JP.99840','2026-08-06',5279.5,5360.7,5300.4,5306.9,901468,1.0),
  ('JP.99840','2026-08-07',5321.5,5389.3,5297.5,5337.6,972566,1.0),
  ('JP.99840','2026-08-10',5310.3,5378.7,5283.9,5326,893933,1.0),
  ('JP.99840','2026-08-11',5380.6,5444.9,5378.9,5381.8,847394,1.0),
  ('JP.99840','2026-08-12',5356.6,5422.6,5382.2,5387.9,852783,1.0),
  ('JP.99840','2026-08-13',5373.8,5353,5288.2,5352.1,804862,1.0),
  ('JP.99840','2026-08-14',5404.4,5374.5,5349.6,5374.4,754625,1.0),
  ('JP.99840','2026-08-17',5355.7,5406.4,5350.8,5381.2,617220,1.0),
  ('JP.99840','2026-08-18',5370.7,5390,5359.7,5386.4,718047,1.0),
  ('JP.99840','2026-08-19',5444.1,5436.5,5396.4,5436.2,720550,1.0),
  ('JP.99840','2026-08-20',5443.8,5423.4,5386.7,5417.2,692975,1.0),
  ('JP.99840','2026-08-21',5489.7,5500.3,5443.9,5472.3,667784,1.0),
  ('JP.99840','2026-08-24',5446.3,5441.9,5434.9,5437.6,720689,1.0),
  ('JP.99840','2026-08-25',5470.5,5490.6,5407,5466.1,736679,1.0),
  ('JP.99840','2026-08-26',5442.2,5510.8,5471.4,5472.1,660485,1.0),
  ('JP.99840','2026-08-27',5529.9,5574.6,5505.2,5526.6,663626,1.0);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-03',38.34,-60.3,-67.7,7.4,5210.22,5275.36,5538.84,5536.99,75.71,820220.65,0.8441,-0.027107,-0.101139,5888.9,5183.1);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-03','golden_cross',2,'{"met":["macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-03','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-03','v1-technical',28,0,3,13,2,4,0,NULL,NULL,'AVOID',5222.2,5070.78,5449.32,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-06',37.27,-57.3,-65.62,8.31,5208.6,5268.51,5531.12,5533.82,72.77,793034.05,0.7893,-0.02588,-0.09556,5888.9,5183.1);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-06','golden_cross',2,'{"met":["macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-06','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-06','v1-technical',21,0,3,13,0,1,0,NULL,NULL,'AVOID',5213.1,5067.56,5431.41,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-07',34.05,-56.59,-63.81,7.22,5208.3,5261.36,5523,5530.3,71.94,777704.6,0.9206,-0.022365,-0.102564,5888.9,5183.1);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-07','golden_cross',2,'{"met":["macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-07','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-07','v1-technical',21,0,3,10,0,4,0,NULL,NULL,'AVOID',5184.4,5040.51,5400.23,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-08',32.35,-56.7,-62.39,5.69,5199.22,5254.64,5514.83,5526.93,70.68,765229.3,0.9651,-0.029811,-0.100621,5888.9,5168.1);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-08','golden_cross',2,'{"met":["macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-08','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-08','v1-technical',21,0,3,10,0,4,0,NULL,NULL,'AVOID',5168.1,5026.73,5380.15,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-09',32.61,-56.03,-61.12,5.09,5191.42,5248.16,5506.88,5523.45,70.14,748656.7,0.988,-0.028437,-0.099315,5888.9,5168.1);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-09','golden_cross',2,'{"met":["macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-09','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-09','v1-technical',21,0,3,10,0,4,0,NULL,NULL,'AVOID',5169.3,5029.03,5379.71,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-10',31.03,-56.02,-60.1,4.08,5177.96,5239.64,5498.69,5519.92,71.1,742991.3,1.1304,-0.020037,-0.107608,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-10','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-10','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-10','v1-technical',21,0,3,10,0,4,0,NULL,NULL,'AVOID',5154.9,5012.71,5368.19,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-13',42.69,-50.92,-58.26,7.34,5177.5,5234.01,5490.68,5516.61,74.15,737176.8,1.1848,-0.013218,-0.092053,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-13','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-13','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-13','v1-technical',28,0,5,13,0,4,0,NULL,NULL,'AVOID',5210.8,5062.49,5433.26,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-14',38.08,-49.31,-56.47,7.17,5175.34,5228.84,5482.12,5513.07,73.6,733419,1.1678,-0.018795,-0.10154,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-14','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-14','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-14','v1-technical',21,0,3,10,0,4,0,NULL,NULL,'AVOID',5173.6,5026.4,5394.4,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-15',46.26,-43.59,-53.9,10.3,5186.18,5224.65,5474.76,5510.01,72.21,746648.75,1.4174,-0.004461,-0.086723,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-15','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-15','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-15','v1-technical',38,0,7,13,2,8,0,NULL,NULL,'AVOID',5222.3,5077.88,5438.92,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-16',39.92,-42.96,-51.71,8.75,5185.92,5218.55,5466.07,5506.64,75.08,751422.8,1.237,-0.021082,-0.09962,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-16','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-16','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-16','v1-technical',26,0,3,10,0,8,0,NULL,NULL,'AVOID',5168,5017.84,5393.24,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-17',40.18,-41.84,-49.73,7.9,5188.86,5214.92,5457.7,5503.29,73.56,771689.9,1.4667,-0.018772,-0.098729,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-17','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-17','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-17','v1-technical',31,0,5,10,2,8,0,NULL,NULL,'AVOID',5169.6,5022.48,5390.28,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-20',43.23,-39.02,-47.59,8.57,5184.3,5211.22,5449.75,5499.96,72.56,785680.85,1.34,-0.013688,-0.090287,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-20','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-20','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-20','v1-technical',33,0,5,13,0,8,0,NULL,NULL,'AVOID',5188,5042.88,5405.69,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-21',42.38,-36.9,-45.45,8.55,5185.84,5207.56,5441.36,5496.55,71.1,800755.25,1.2991,-0.009027,-0.094716,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-21','golden_cross',3,'{"met":["macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-21','exit',2,'{"met":["below_sma25","sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-21','v1-technical',31,0,5,10,2,8,0,NULL,NULL,'AVOID',5181.3,5039.1,5394.6,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-22',52.17,-29.62,-42.29,12.66,5190.66,5207.59,5433.82,5493.76,72.8,820944.8,1.3332,-0.000076,-0.072517,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-22','golden_cross',6,'{"met":["sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-22','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-22','v1-technical',54,10,10,13,2,8,0,NULL,NULL,'WATCH',5246.4,5155.51,5464.8,2.403);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-23',48.95,-25.45,-38.92,13.47,5201.66,5205.34,5426.55,5490.63,69.29,839794,1.25,0.000077,-0.085449,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-23','golden_cross',4,'{"met":["close_above_sma25","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-23','exit',1,'{"met":["sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-23','v1-technical',48,5,7,13,2,8,3,NULL,NULL,'AVOID',5223,5153.28,5430.86,2.981);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-24',47.95,-22.49,-35.63,13.15,5210.86,5203.22,5418.63,5487.61,72.48,864366.9,1.3623,0.00627,-0.08053,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-24','golden_cross',5,'{"met":["sma5_above_sma25","close_above_sma25","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":true,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-24','exit',1,'{"met":["sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-24','v1-technical',50,5,7,10,7,8,3,NULL,NULL,'AVOID',5215.6,5151.19,5433.04,3.376);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-27',50.14,-18.73,-32.25,13.52,5219.32,5202.03,5411.51,5484.64,74.25,882139.85,1.2,0.001743,-0.074774,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-27','golden_cross',6,'{"met":["sma5_above_sma25","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-27','exit',1,'{"met":["sma25_falling"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-27','v1-technical',57,5,10,13,7,8,3,NULL,NULL,'AVOID',5230.3,5150.01,5453.06,2.774);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-28',56.81,-11.59,-28.12,16.53,5239.12,5204.1,5404.89,5481.85,74.96,910336.5,1.2864,0.018203,-0.068484,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-28','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-28','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-28','v1-technical',64,10,10,13,7,8,3,NULL,NULL,'BUY_WATCH',5280.3,5152.06,5505.17,1.754);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-29',52.38,-8.21,-24.14,15.93,5240.02,5204.27,5398.28,5479.21,73.09,935539.3,1.304,0.007174,-0.070045,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-29','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-29','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-29','v1-technical',60,10,10,10,7,8,3,NULL,NULL,'BUY_WATCH',5250.9,5152.23,5470.18,2.222);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-30',57.59,-2.03,-19.72,17.68,5254.2,5207.12,5392.35,5476.66,75.05,962321.1,1.2262,0.016435,-0.054559,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-30','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-30','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-30','v1-technical',64,10,10,13,7,8,3,NULL,NULL,'BUY_WATCH',5293.9,5155.05,5519.04,1.621);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-07-31',58.78,3.67,-15.04,18.71,5271.96,5211.97,5386.05,5474.35,74.94,981391.1,1.0941,0.01574,-0.048487,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-31','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-07-31','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-07-31','v1-technical',66,10,10,15,7,4,7,NULL,NULL,'BUY_WATCH',5304.4,5159.85,5529.23,1.555);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-03',52.72,4.9,-11.05,15.95,5278.78,5213.7,5379.72,5471.73,75.87,998909.85,0.9774,0.009841,-0.064589,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-03','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-03','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-03','v1-technical',57,10,10,12,7,4,3,NULL,NULL,'WATCH',5264.4,5161.56,5492.02,2.213);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-04',54.34,6.83,-7.48,14.3,5278.16,5217.35,5373.31,5469.26,76.06,1011379.35,0.9544,0.0179,-0.053536,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-04','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-04','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-04','v1-technical',55,10,10,12,5,4,3,NULL,NULL,'WATCH',5277.2,5165.18,5505.39,2.037);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-05',56.75,9.8,-4.02,13.82,5287.28,5220.67,5367.68,5467.02,73.99,1022151.8,0.9333,0.024845,-0.054112,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-05','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-05','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-05','v1-technical',57,10,10,12,7,4,3,NULL,NULL,'WATCH',5296.5,5168.47,5518.48,1.734);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-06',58.04,12.85,-0.65,13.5,5289.88,5224.62,5361.91,5464.91,73.29,1030239.85,0.875,0.026619,-0.043853,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-06','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-06','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-06','v1-technical',63,10,10,12,7,4,7,NULL,NULL,'BUY_WATCH',5306.9,5172.37,5526.78,1.634);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-07',61.66,17.54,2.99,14.55,5296.52,5229.23,5356.6,5463.14,74.62,1036873.65,0.938,0.035442,-0.034408,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-07','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-07','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-07','v1-technical',66,10,10,15,7,4,7,NULL,NULL,'BUY_WATCH',5337.6,5176.94,5561.45,1.393);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-10',59.57,20.09,6.41,13.68,5308.84,5233.75,5351.58,5461.34,76.06,1037899.4,0.8613,0.022108,-0.039582,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-10','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-10','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-10','v1-technical',63,10,10,12,7,4,7,NULL,NULL,'BUY_WATCH',5326,5181.41,5554.17,1.578);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-11',65.61,26.31,10.39,15.92,5329.76,5241.64,5347.02,5459.86,79.12,1037445.05,0.8168,0.040243,-0.02238,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-11','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-11','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-11','v1-technical',70,15,8,15,7,4,7,NULL,NULL,'BUY_WATCH',5381.8,5189.23,5619.15,1.233);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-12',66.2,31.37,14.59,16.78,5348.04,5250.44,5343.44,5458.2,76.38,1027171.05,0.8302,0.03171,-0.016699,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-12','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-12','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-12','v1-technical',70,15,8,15,7,4,7,NULL,NULL,'BUY_WATCH',5387.9,5197.93,5617.04,1.206);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-13',59.68,32.12,18.09,14.03,5357.08,5257.75,5338.65,5456.43,78.05,1020937.95,0.7884,0.035623,-0.025988,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-13','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-13','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-13','v1-technical',65,15,10,12,7,1,7,NULL,NULL,'BUY_WATCH',5352.1,5205.17,5586.24,1.594);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-14',62.18,34.12,21.3,12.82,5364.44,5266.53,5334.68,5454.94,74.25,1002075.5,0.7531,0.039616,-0.0171,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-14','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-14','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-14','v1-technical',65,15,10,12,7,1,7,NULL,NULL,'BUY_WATCH',5374.4,5213.86,5597.15,1.388);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-17',62.94,35.84,24.21,11.64,5375.48,5273.34,5331.06,5453.52,72.92,980296,0.6296,0.03724,-0.015478,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-17','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-17','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-17','v1-technical',65,15,10,12,7,1,7,NULL,NULL,'BUY_WATCH',5381.2,5220.61,5599.95,1.362);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-18',63.54,37.2,26.81,10.39,5376.4,5281.86,5327.29,5452.25,69.87,964184.95,0.7447,0.039585,-0.006236,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-18','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-18','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-18','v1-technical',65,15,10,12,7,1,7,NULL,NULL,'BUY_WATCH',5386.4,5229.04,5596.02,1.332);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-19',68.75,41.81,29.81,12,5386.06,5290.41,5324.49,5451.35,68.46,945487.7,0.7621,0.036177,0.003526,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-19','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-19','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-19','v1-technical',70,15,8,15,7,1,10,NULL,NULL,'BUY_WATCH',5436.2,5299.28,5641.58,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-20',64.93,43.43,32.53,10.9,5399.08,5300.38,5322.06,5450.4,67.11,927649.55,0.747,0.037182,-0.003458,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-20','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-20','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-20','v1-technical',65,15,10,12,7,1,7,NULL,NULL,'BUY_WATCH',5417.2,5247.38,5618.52,1.185);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-21',70.11,48.6,35.75,12.85,5418.66,5312.49,5320.7,5449.75,68.25,902160.8,0.7402,0.049218,0.011703,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-21','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-21','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-21','v1-technical',69,15,4,15,10,1,10,NULL,NULL,'BUY_WATCH',5472.3,5335.8,5677.05,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-24',63.73,49.33,38.46,10.87,5429.94,5322.47,5318.16,5449.01,66.05,885264.9,0.8141,0.039634,0.009899,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-24','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-24','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-24','v1-technical',79,15,10,12,12,4,10,NULL,NULL,'BUY_WATCH',5437.6,5269.25,5635.74,1.177);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-25',66.43,51.61,41.09,10.52,5445.88,5333.86,5316.7,5448.39,67.3,863543.95,0.8531,0.035187,0.019205,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-25','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-25','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-25','v1-technical',80,15,8,12,15,4,10,NULL,NULL,'BUY_WATCH',5466.1,5280.53,5668,1.088);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-26',66.99,53.29,43.53,9.76,5453.06,5342.89,5315,5448.01,65.69,835573,0.7905,0.042126,0.025468,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-26','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-26','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-26','v1-technical',76,15,8,12,15,1,10,NULL,NULL,'BUY_WATCH',5472.1,5289.46,5669.16,1.079);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.99840','2026-08-27',71.6,58.34,46.49,11.85,5474.94,5355.04,5314.68,5447.8,68.32,809753.95,0.8195,0.043956,0.036613,5888.9,5154.9);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-27','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.99840','2026-08-27','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.99840','2026-08-27','v1-technical',79,15,4,15,15,4,10,NULL,NULL,'BUY_WATCH',5526.6,5389.97,5731.55,1.5);

INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.80580','2025-08-29',3040.9,3051.5,3033.7,3034.3,827245,1.0),
  ('JP.80580','2025-09-01',3064.9,3077.2,3030.7,3059.4,877960,1.0),
  ('JP.80580','2025-09-02',3042,3067.8,3043.4,3049.1,912623,1.0),
  ('JP.80580','2025-09-03',3024.7,3051.9,3027.5,3037.6,981614,1.0),
  ('JP.80580','2025-09-04',3047.9,3059.7,3049.4,3056.9,1047754,1.0),
  ('JP.80580','2025-09-05',3070.7,3058.3,3052.5,3053.5,1052838,1.0),
  ('JP.80580','2025-09-08',3037.1,3086.7,3017.4,3050.9,1085518,1.0),
  ('JP.80580','2025-09-09',3053,3095.2,3042.1,3059.4,1122882,1.0),
  ('JP.80580','2025-09-10',3074.5,3070.7,3024.7,3056.4,1140021,1.0),
  ('JP.80580','2025-09-11',3065.7,3063.6,3056.8,3060.7,1123567,1.0),
  ('JP.80580','2025-09-12',3065.4,3077.6,3063.8,3071.1,1247156,1.0),
  ('JP.80580','2025-09-15',3076.8,3097.1,3073.3,3073.7,1126100,1.0),
  ('JP.80580','2025-09-16',3073.2,3089.3,3022.4,3057.1,1190599,1.0),
  ('JP.80580','2025-09-17',3039.7,3077.8,3036,3047.2,1098319,1.0),
  ('JP.80580','2025-09-18',3052.4,3058.4,3028.1,3055.2,1051634,1.0),
  ('JP.80580','2025-09-19',3070.8,3073.1,3025.4,3058.3,963681,1.0),
  ('JP.80580','2025-09-22',3066.1,3078.8,3054.5,3069.2,982038,1.0),
  ('JP.80580','2025-09-23',3036.9,3074.7,3019,3040.4,1041592,1.0),
  ('JP.80580','2025-09-24',3049.2,3069.4,3036.6,3053.7,854181,1.0),
  ('JP.80580','2025-09-25',3056.4,3070.3,3026.7,3058.9,952877,1.0),
  ('JP.80580','2025-09-26',3043.1,3078.8,3036.1,3054.3,823967,1.0),
  ('JP.80580','2025-09-29',3053,3067.2,3007.7,3039.4,748559,1.0),
  ('JP.80580','2025-09-30',3035.4,3046.6,3017.7,3037.3,762800,1.0),
  ('JP.80580','2025-10-01',3028.6,3054.1,2984.8,3019.8,827431,1.0),
  ('JP.80580','2025-10-02',3016.6,3032.4,3011.8,3024.4,786818,1.0),
  ('JP.80580','2025-10-03',3018.3,3028.3,2990,3024,710406,1.0),
  ('JP.80580','2025-10-06',3027.9,3075.8,3009.8,3041,647783,1.0),
  ('JP.80580','2025-10-07',3018.4,3045.7,3003.1,3020.8,600017,1.0),
  ('JP.80580','2025-10-08',3027.4,3060.8,2988.8,3024.7,562724,1.0),
  ('JP.80580','2025-10-09',3044.8,3038.5,3017.4,3027.8,634058,1.0),
  ('JP.80580','2025-10-10',3003.4,2999.2,2971,2993.1,661144,1.0),
  ('JP.80580','2025-10-13',2985.2,3002.2,2966.7,2987.3,705841,1.0),
  ('JP.80580','2025-10-14',2997,3025,2976.8,3003.5,631899,1.0),
  ('JP.80580','2025-10-15',2995.9,3020.4,2989.2,3007.2,632273,1.0),
  ('JP.80580','2025-10-16',2981,3003.6,2961.8,2983.2,669225,1.0),
  ('JP.80580','2025-10-17',3004.3,3022.7,2987,2997.9,767550,1.0),
  ('JP.80580','2025-10-20',2951.7,2989.9,2939.3,2962.4,861270,1.0),
  ('JP.80580','2025-10-21',2986.1,3009.5,2940.2,2974.6,847113,1.0),
  ('JP.80580','2025-10-22',2968,2973.5,2949.6,2958.4,847479,1.0),
  ('JP.80580','2025-10-23',2947,2985.3,2927.6,2961.8,966244,1.0),
  ('JP.80580','2025-10-24',2952.5,2983,2947.9,2955.5,905721,1.0),
  ('JP.80580','2025-10-27',2938.6,2972.2,2936.9,2938.1,1112635,1.0),
  ('JP.80580','2025-10-28',2926.4,2949.5,2904.8,2934.3,1128645,1.0),
  ('JP.80580','2025-10-29',2947.6,2956.9,2943.7,2948,1045175,1.0),
  ('JP.80580','2025-10-30',2917.7,2946.4,2904.2,2931.1,1023944,1.0),
  ('JP.80580','2025-10-31',2918.4,2940.3,2890.6,2923.8,1104279,1.0),
  ('JP.80580','2025-11-03',2951.5,2945.4,2931.1,2936.1,1237479,1.0),
  ('JP.80580','2025-11-04',2916.4,2931.4,2902.8,2919.5,1215137,1.0),
  ('JP.80580','2025-11-05',2891.5,2910.6,2902,2906,1164023,1.0),
  ('JP.80580','2025-11-06',2905.6,2931.7,2915.8,2918.2,1066519,1.0),
  ('JP.80580','2025-11-07',2891,2929.2,2884.4,2902.1,1090312,1.0),
  ('JP.80580','2025-11-10',2903,2928.1,2871.4,2893.9,1076930,1.0),
  ('JP.80580','2025-11-11',2888.2,2896.7,2876.8,2891.8,1021564,1.0),
  ('JP.80580','2025-11-12',2895,2898.9,2875.1,2886.1,1059351,1.0),
  ('JP.80580','2025-11-13',2904.7,2926.6,2889.1,2896.9,988159,1.0),
  ('JP.80580','2025-11-14',2878.6,2926.9,2878.8,2893.4,928058,1.0),
  ('JP.80580','2025-11-17',2877.7,2873.7,2858.5,2872.8,826300,1.0),
  ('JP.80580','2025-11-18',2891.4,2917.3,2864,2892.4,918594,1.0),
  ('JP.80580','2025-11-19',2883.8,2885.1,2857.7,2875.8,887615,1.0),
  ('JP.80580','2025-11-20',2895.6,2891.8,2883.8,2887.4,877344,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.80580','2025-11-21',2873.9,2864.6,2856.9,2862.6,670408,1.0),
  ('JP.80580','2025-11-24',2861.5,2901.9,2869.1,2874,782856,1.0),
  ('JP.80580','2025-11-25',2878.5,2890.5,2859.7,2885.1,692017,1.0),
  ('JP.80580','2025-11-26',2868.5,2883.7,2840.5,2873.3,649525,1.0),
  ('JP.80580','2025-11-27',2853.9,2899.8,2854.3,2870.4,650077,1.0),
  ('JP.80580','2025-11-28',2883.1,2905.8,2849.6,2872.7,698043,1.0),
  ('JP.80580','2025-12-01',2846.1,2884.1,2845.1,2854.6,562844,1.0),
  ('JP.80580','2025-12-02',2853.9,2892.9,2832.7,2863.9,618635,1.0),
  ('JP.80580','2025-12-03',2852,2878.9,2846.3,2855.2,747680,1.0),
  ('JP.80580','2025-12-04',2892.9,2908,2843.9,2877.5,664933,1.0),
  ('JP.80580','2025-12-05',2888.9,2894.9,2861.6,2883.6,704763,1.0),
  ('JP.80580','2025-12-08',2870.6,2875.8,2873.5,2874.7,661096,1.0),
  ('JP.80580','2025-12-09',2859,2871.3,2846.5,2865.1,832624,1.0),
  ('JP.80580','2025-12-10',2859,2861.1,2851.1,2858.2,744747,1.0),
  ('JP.80580','2025-12-11',2886.5,2888.8,2864.5,2880,925723,1.0),
  ('JP.80580','2025-12-12',2860.3,2900.3,2857.3,2872,866118,1.0),
  ('JP.80580','2025-12-15',2863,2875.8,2865.1,2865.7,1004412,1.0),
  ('JP.80580','2025-12-16',2885.8,2917.9,2855.1,2887.1,881948,1.0),
  ('JP.80580','2025-12-17',2899.3,2915.4,2879.3,2890.8,916883,1.0),
  ('JP.80580','2025-12-18',2901.8,2922.7,2878.8,2895.5,983607,1.0),
  ('JP.80580','2025-12-19',2871.8,2919.9,2882,2888.7,1143494,1.0),
  ('JP.80580','2025-12-22',2899.9,2939.8,2878.1,2906.9,1145197,1.0),
  ('JP.80580','2025-12-23',2902.3,2926.8,2890.3,2895.2,1038729,1.0),
  ('JP.80580','2025-12-24',2928.4,2921.4,2888.3,2915.6,1131502,1.0),
  ('JP.80580','2025-12-25',2912.2,2931.1,2893.6,2920,1177524,1.0),
  ('JP.80580','2025-12-26',2914.2,2939.3,2915.2,2926.2,1130051,1.0),
  ('JP.80580','2025-12-29',2912.1,2941.9,2904.1,2929,1243172,1.0),
  ('JP.80580','2025-12-30',2930.2,2952.4,2936.6,2937.6,1128828,1.0),
  ('JP.80580','2025-12-31',2941.2,2946.8,2914.1,2929,1016166,1.0),
  ('JP.80580','2026-01-01',2927.7,2973.6,2908,2939.8,1113718,1.0),
  ('JP.80580','2026-01-02',2971.4,2977.8,2944.5,2956,1009465,1.0),
  ('JP.80580','2026-01-05',2958.9,2984.9,2937.3,2962.5,1070191,1.0),
  ('JP.80580','2026-01-06',2983.5,2999.6,2943.2,2965.7,958409,1.0),
  ('JP.80580','2026-01-07',2940.8,2992.3,2927.4,2957.3,1004369,1.0),
  ('JP.80580','2026-01-08',3004,2994.3,2970.8,2987.7,825326,1.0),
  ('JP.80580','2026-01-09',2977.1,3011.4,2969.3,2986.9,812215,1.0),
  ('JP.80580','2026-01-12',2976.7,2992,2954.2,2978.8,832187,1.0),
  ('JP.80580','2026-01-13',3010,3032.3,2990.4,3008.8,784314,1.0),
  ('JP.80580','2026-01-14',3024.2,3048.8,3005.7,3026.6,802111,1.0),
  ('JP.80580','2026-01-15',3021.2,3023.1,2999.6,3017.7,700408,1.0),
  ('JP.80580','2026-01-16',3024,3052.9,3016.2,3027.3,784444,1.0),
  ('JP.80580','2026-01-19',3055.4,3048.5,3028.5,3042.4,604715,1.0),
  ('JP.80580','2026-01-20',3050.5,3056.8,3007.6,3036.9,671180,1.0),
  ('JP.80580','2026-01-21',3053.3,3061.7,3020.9,3056.8,722827,1.0),
  ('JP.80580','2026-01-22',3074.1,3076.4,3046.7,3071.4,697023,1.0),
  ('JP.80580','2026-01-23',3043.7,3088.9,3027,3053.5,745968,1.0),
  ('JP.80580','2026-01-26',3084.3,3102.8,3085.6,3091,664018,1.0),
  ('JP.80580','2026-01-27',3083.5,3110.3,3048.3,3085.1,731242,1.0),
  ('JP.80580','2026-01-28',3083.9,3104.1,3088.5,3102.4,656837,1.0),
  ('JP.80580','2026-01-29',3091.6,3119.9,3086.9,3096.7,709631,1.0),
  ('JP.80580','2026-01-30',3130.9,3135.2,3102.1,3114.8,829036,1.0),
  ('JP.80580','2026-02-02',3102.9,3135.7,3114.8,3121.1,819427,1.0),
  ('JP.80580','2026-02-03',3111.8,3130.6,3091.2,3125.6,756366,1.0),
  ('JP.80580','2026-02-04',3117,3137.9,3105,3122.3,954048,1.0),
  ('JP.80580','2026-02-05',3131.3,3148.4,3114.4,3127.4,983084,1.0),
  ('JP.80580','2026-02-06',3176.5,3172.7,3134.8,3158.7,992263,1.0),
  ('JP.80580','2026-02-09',3148.9,3153.7,3124.2,3148.5,943639,1.0),
  ('JP.80580','2026-02-10',3171.4,3199.7,3168.5,3175.7,1028223,1.0),
  ('JP.80580','2026-02-11',3163.4,3202.4,3155,3172.2,1137560,1.0),
  ('JP.80580','2026-02-12',3173.4,3207.1,3156,3180.3,1100933,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.80580','2026-02-13',3204.8,3228,3184.9,3194.1,1082473,1.0),
  ('JP.80580','2026-02-16',3172.9,3187.6,3151.4,3186.2,1100312,1.0),
  ('JP.80580','2026-02-17',3178.2,3205.6,3181.5,3190,1081300,1.0),
  ('JP.80580','2026-02-18',3202.3,3207.1,3184.7,3206.7,1062383,1.0),
  ('JP.80580','2026-02-19',3213.8,3250.6,3219.3,3227.7,1227402,1.0),
  ('JP.80580','2026-02-20',3233.5,3222.4,3190.9,3216.8,1121782,1.0),
  ('JP.80580','2026-02-23',3229.8,3263.6,3201.4,3233.9,1048208,1.0),
  ('JP.80580','2026-02-24',3231.1,3247.6,3205.3,3215.7,1028327,1.0),
  ('JP.80580','2026-02-25',3236.6,3270.3,3207,3244.9,966247,1.0),
  ('JP.80580','2026-02-26',3253.7,3248.7,3223.2,3242.7,918165,1.0),
  ('JP.80580','2026-02-27',3232.7,3270.5,3226.1,3248.5,1048893,1.0),
  ('JP.80580','2026-03-02',3270.7,3286.4,3219.2,3253.7,1021696,1.0),
  ('JP.80580','2026-03-03',3254.4,3266,3238.5,3253.5,937136,1.0),
  ('JP.80580','2026-03-04',3231,3272.2,3242.6,3243.9,952399,1.0),
  ('JP.80580','2026-03-05',3256.2,3276,3231,3248.1,901704,1.0),
  ('JP.80580','2026-03-06',3236.4,3251.8,3215.2,3243.3,815428,1.0),
  ('JP.80580','2026-03-09',3276.5,3275.9,3273.3,3273.5,684500,1.0),
  ('JP.80580','2026-03-10',3238.3,3292.9,3237.8,3255.1,764930,1.0),
  ('JP.80580','2026-03-11',3286.7,3285.8,3264.1,3274,656895,1.0),
  ('JP.80580','2026-03-12',3300.4,3306.4,3251.2,3282,686884,1.0),
  ('JP.80580','2026-03-13',3272.5,3296.3,3266.8,3279.4,676691,1.0),
  ('JP.80580','2026-03-16',3264,3279.3,3229.4,3268.5,552390,1.0),
  ('JP.80580','2026-03-17',3275.9,3292.3,3260.5,3286.1,564738,1.0),
  ('JP.80580','2026-03-18',3245.1,3274.8,3217.6,3254.2,737350,1.0),
  ('JP.80580','2026-03-19',3259.5,3293.2,3237.1,3262.5,763042,1.0),
  ('JP.80580','2026-03-20',3264.1,3314.7,3245,3278,600691,1.0),
  ('JP.80580','2026-03-23',3274.1,3294.7,3225.3,3256.7,791037,1.0),
  ('JP.80580','2026-03-24',3267.1,3268.3,3229.1,3265.9,717384,1.0),
  ('JP.80580','2026-03-25',3252.1,3256.7,3225.7,3249.5,798074,1.0),
  ('JP.80580','2026-03-26',3287.3,3295.5,3241.3,3272.8,736866,1.0),
  ('JP.80580','2026-03-27',3259.6,3291.7,3222.8,3256.4,930707,1.0),
  ('JP.80580','2026-03-30',3237.8,3271,3225.5,3254.6,944695,1.0),
  ('JP.80580','2026-03-31',3277.8,3274.2,3251.2,3263.3,1005341,1.0),
  ('JP.80580','2026-04-01',3226.9,3282,3230.7,3244,1007724,1.0),
  ('JP.80580','2026-04-02',3274.5,3264,3245,3260.2,1012941,1.0),
  ('JP.80580','2026-04-03',3228.8,3253.3,3199.8,3232.5,1143481,1.0),
  ('JP.80580','2026-04-06',3259.8,3256.7,3232.9,3255.4,1095181,1.0),
  ('JP.80580','2026-04-07',3244.8,3262.6,3200.7,3236.3,1035016,1.0),
  ('JP.80580','2026-04-08',3265.3,3273.2,3235.5,3247.1,1133146,1.0),
  ('JP.80580','2026-04-09',3236,3254.3,3207.7,3227.4,1076034,1.0),
  ('JP.80580','2026-04-10',3212,3242.5,3181.5,3219.3,1193048,1.0),
  ('JP.80580','2026-04-13',3206.7,3233.8,3198.9,3213.9,1139860,1.0),
  ('JP.80580','2026-04-14',3244.5,3271.9,3231.9,3234,1090807,1.0),
  ('JP.80580','2026-04-15',3215,3217.2,3203.6,3213.1,1082470,1.0),
  ('JP.80580','2026-04-16',3235.4,3248.2,3204.9,3221.2,1081320,1.0),
  ('JP.80580','2026-04-17',3212.5,3209.8,3197.3,3208.4,976724,1.0),
  ('JP.80580','2026-04-20',3212.4,3217.9,3201.6,3208.6,1061296,1.0),
  ('JP.80580','2026-04-21',3184.7,3221.2,3161.2,3192.9,1094721,1.0),
  ('JP.80580','2026-04-22',3182.2,3200.9,3170.3,3190.6,909130,1.0),
  ('JP.80580','2026-04-23',3178.2,3195.5,3147,3184.9,870267,1.0),
  ('JP.80580','2026-04-24',3186.4,3210.4,3165,3176,983952,1.0),
  ('JP.80580','2026-04-27',3167,3219.4,3161.1,3185.7,746331,1.0),
  ('JP.80580','2026-04-28',3150.3,3176.1,3157,3163.9,781233,1.0),
  ('JP.80580','2026-04-29',3147.2,3168.3,3141.8,3148.4,705553,1.0),
  ('JP.80580','2026-04-30',3146.2,3168.7,3153.3,3161,806585,1.0),
  ('JP.80580','2026-05-01',3167.4,3167,3144.7,3157.1,657860,1.0),
  ('JP.80580','2026-05-04',3161.5,3153.4,3114.7,3145.9,695245,1.0),
  ('JP.80580','2026-05-05',3166,3188.4,3149.2,3152.5,680534,1.0),
  ('JP.80580','2026-05-06',3112.2,3156.9,3088.8,3122.5,584586,1.0),
  ('JP.80580','2026-05-07',3106.7,3141.1,3084.8,3116.3,635196,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.80580','2026-05-08',3133.2,3150.9,3106.6,3125.3,553461,1.0),
  ('JP.80580','2026-05-11',3109.2,3131.6,3103.6,3122.9,685508,1.0),
  ('JP.80580','2026-05-12',3113.6,3132.1,3112.2,3123.5,687644,1.0),
  ('JP.80580','2026-05-13',3120.9,3137.1,3104.7,3123.2,771671,1.0),
  ('JP.80580','2026-05-14',3106.6,3147.8,3097.5,3121.8,827679,1.0),
  ('JP.80580','2026-05-15',3108.9,3137.9,3097.4,3114.3,725222,1.0),
  ('JP.80580','2026-05-18',3096.1,3110.6,3098.3,3105.6,816558,1.0),
  ('JP.80580','2026-05-19',3112.5,3132.2,3076.5,3097.8,893004,1.0),
  ('JP.80580','2026-05-20',3072.8,3106.3,3081.6,3088.8,902275,1.0),
  ('JP.80580','2026-05-21',3112.1,3099.5,3064.4,3097.4,844799,1.0),
  ('JP.80580','2026-05-22',3088.8,3116.5,3053.8,3082,977070,1.0),
  ('JP.80580','2026-05-25',3097.7,3132.3,3075.9,3096.9,1027533,1.0),
  ('JP.80580','2026-05-26',3081,3106.7,3072,3087.9,963435,1.0),
  ('JP.80580','2026-05-27',3074.4,3087.6,3076.7,3083.8,1062773,1.0),
  ('JP.80580','2026-05-28',3075.1,3101,3059.5,3078.2,999349,1.0),
  ('JP.80580','2026-05-29',3046,3068,3058.1,3064.3,1025810,1.0),
  ('JP.80580','2026-06-01',3084.1,3112.5,3064.4,3089.3,1144136,1.0),
  ('JP.80580','2026-06-02',3068.5,3092,3085.7,3086.5,1056516,1.0),
  ('JP.80580','2026-06-03',3050.5,3073.3,3040,3062.8,1234357,1.0),
  ('JP.80580','2026-06-04',3081.8,3097.1,3065.6,3084.3,1096956,1.0),
  ('JP.80580','2026-06-05',3064.3,3111.3,3046.2,3075.9,1078758,1.0),
  ('JP.80580','2026-06-08',3067.8,3114.6,3052.6,3080.9,1190750,1.0),
  ('JP.80580','2026-06-09',3090.2,3115,3047.6,3084,1104915,1.0),
  ('JP.80580','2026-06-10',3096.6,3097.1,3079.3,3091.1,1077091,1.0),
  ('JP.80580','2026-06-11',3065.2,3092.1,3061.3,3065.1,1070505,1.0),
  ('JP.80580','2026-06-12',3059.1,3076.3,3039.5,3071.3,930520,1.0),
  ('JP.80580','2026-06-15',3074.5,3091.9,3055.3,3069.7,1041372,1.0),
  ('JP.80580','2026-06-16',3079,3097.5,3083.6,3084.4,898575,1.0),
  ('JP.80580','2026-06-17',3090.5,3088.4,3048.3,3084.2,929445,1.0),
  ('JP.80580','2026-06-18',3081.3,3107.8,3076,3098.5,735735,1.0),
  ('JP.80580','2026-06-19',3078.2,3108.4,3056.6,3083.4,788469,1.0),
  ('JP.80580','2026-06-22',3079.5,3116.8,3064.3,3096.6,786233,1.0),
  ('JP.80580','2026-06-23',3093.1,3130,3093.8,3111.5,796967,1.0),
  ('JP.80580','2026-06-24',3114.3,3108.9,3094.4,3102.2,792717,1.0),
  ('JP.80580','2026-06-25',3134.7,3130.1,3124,3127.5,728378,1.0),
  ('JP.80580','2026-06-26',3102.8,3131.4,3085.6,3110.2,564977,1.0),
  ('JP.80580','2026-06-29',3125,3108.4,3075.3,3107.4,730369,1.0),
  ('JP.80580','2026-06-30',3110.5,3141,3105.6,3115.7,595490,1.0),
  ('JP.80580','2026-07-01',3130.1,3165.8,3120.1,3128.5,721453,1.0),
  ('JP.80580','2026-07-02',3111.9,3142.8,3103.5,3129.5,718844,1.0),
  ('JP.80580','2026-07-03',3162.4,3173.4,3149.5,3164.1,675704,1.0),
  ('JP.80580','2026-07-06',3172.3,3201.3,3135.2,3169.8,642771,1.0),
  ('JP.80580','2026-07-07',3144.5,3187.1,3132,3154.7,818076,1.0),
  ('JP.80580','2026-07-08',3172.3,3204.8,3132,3167.9,691927,1.0),
  ('JP.80580','2026-07-09',3171.8,3187.8,3180.5,3185.6,906143,1.0),
  ('JP.80580','2026-07-10',3173.9,3214.5,3183.7,3190.8,764322,1.0),
  ('JP.80580','2026-07-13',3190.2,3223.7,3189.2,3193.8,841401,1.0),
  ('JP.80580','2026-07-14',3182.6,3233.7,3174.7,3198.5,966887,1.0),
  ('JP.80580','2026-07-15',3195.8,3208.7,3160.6,3187.9,1047185,1.0),
  ('JP.80580','2026-07-16',3219.1,3252.4,3201.4,3225.5,1033514,1.0),
  ('JP.80580','2026-07-17',3209.6,3251.6,3209.8,3221.4,1083270,1.0),
  ('JP.80580','2026-07-20',3246.3,3266.3,3208,3231.4,1098657,1.0),
  ('JP.80580','2026-07-21',3223.7,3238.8,3192.5,3230,1051731,1.0),
  ('JP.80580','2026-07-22',3255,3281.4,3217.6,3253.5,1064573,1.0),
  ('JP.80580','2026-07-23',3269.1,3285.1,3242.3,3252.4,1197324,1.0),
  ('JP.80580','2026-07-24',3274.8,3292.2,3251.1,3268.2,1123166,1.0),
  ('JP.80580','2026-07-27',3293.5,3315.9,3280.7,3283.3,1130812,1.0),
  ('JP.80580','2026-07-28',3289.2,3320.7,3277.8,3283.5,1136566,1.0),
  ('JP.80580','2026-07-29',3290.5,3308.9,3285.5,3287.7,1217955,1.0),
  ('JP.80580','2026-07-30',3306.5,3325.2,3280.6,3313.9,1206585,1.0);
INSERT INTO prices_daily (symbol_id, date, open, high, low, close, volume, adjustment_factor) VALUES
  ('JP.80580','2026-07-31',3333.5,3347,3294,3320.8,1092759,1.0),
  ('JP.80580','2026-08-03',3329.1,3363.3,3323.1,3325.2,1034502,1.0),
  ('JP.80580','2026-08-04',3327.6,3321.8,3317.5,3320.2,1083437,1.0),
  ('JP.80580','2026-08-05',3303.1,3321.1,3282.8,3320,1051780,1.0),
  ('JP.80580','2026-08-06',3316.2,3328.6,3322.3,3323.6,996089,1.0),
  ('JP.80580','2026-08-07',3367.4,3383.6,3348.1,3359.6,951760,1.0),
  ('JP.80580','2026-08-10',3364.7,3381.6,3341.7,3362,896587,1.0),
  ('JP.80580','2026-08-11',3360.8,3368.5,3333.3,3359.8,834643,1.0),
  ('JP.80580','2026-08-12',3367.3,3366.9,3359.3,3364.2,878299,1.0),
  ('JP.80580','2026-08-13',3358.6,3393.3,3344.5,3368.1,655618,1.0),
  ('JP.80580','2026-08-14',3413.6,3404.7,3387.7,3398,814390,1.0),
  ('JP.80580','2026-08-17',3414.7,3423.8,3404.3,3405.6,701371,1.0),
  ('JP.80580','2026-08-18',3393.9,3447.4,3401.8,3413.5,581180,1.0),
  ('JP.80580','2026-08-19',3419.6,3447.4,3408.8,3421.9,575881,1.0),
  ('JP.80580','2026-08-20',3437.1,3418.6,3392.2,3418.3,715775,1.0),
  ('JP.80580','2026-08-21',3420.6,3442.2,3397,3408.5,714842,1.0),
  ('JP.80580','2026-08-24',3437.1,3442.7,3389.4,3429.5,749472,1.0),
  ('JP.80580','2026-08-25',3426.9,3426.8,3385.7,3423.2,731853,1.0),
  ('JP.80580','2026-08-26',3452.7,3462.1,3418.3,3451,650834,1.0),
  ('JP.80580','2026-08-27',3464.9,3476.5,3411.2,3451.2,791074,1.0);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-03',66.91,9.2,1.07,8.13,3129.04,3096.18,3148.75,3072.1,38.98,843925.45,0.8007,0.028675,-0.017147,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-03','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-03','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-03','v1-technical',74,15,8,15,10,4,7,NULL,NULL,'BUY_WATCH',3164.1,3065.22,3281.04,1.183);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-06',68.03,12.61,3.38,9.24,3141.52,3099.4,3147.6,3072.75,40.92,816526.5,0.7872,0.028855,-0.013722,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-06','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-06','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-06','v1-technical',70,15,8,15,10,1,7,NULL,NULL,'BUY_WATCH',3169.8,3068.41,3292.55,1.211);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-07',62.02,13.94,5.49,8.45,3149.32,3102.13,3146.11,3073.34,41.93,802184.55,1.0198,0.022925,-0.024521,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-07','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-07','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-07','v1-technical',73,15,10,12,10,4,7,NULL,NULL,'BUY_WATCH',3154.7,3071.11,3280.49,1.505);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-08',64.94,15.88,7.57,8.31,3157.2,3106.34,3145.03,3074.08,44.14,782926.35,0.8838,0.024846,-0.014067,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-08','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-08','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-08','v1-technical',73,15,10,12,10,4,7,NULL,NULL,'BUY_WATCH',3167.9,3075.27,3300.31,1.429);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-09',68.44,18.63,9.78,8.85,3168.42,3110.39,3143.86,3074.88,42.4,774708.25,1.1697,0.039314,-0.011052,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-09','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-09','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-09','v1-technical',74,15,8,15,10,4,7,NULL,NULL,'BUY_WATCH',3185.6,3079.28,3312.81,1.197);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-10',69.4,20.98,12.02,8.96,3173.76,3114.98,3142.99,3075.72,41.58,766398.35,0.9973,0.038909,-0.005486,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-10','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-10','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-10','v1-technical',74,15,8,15,10,4,7,NULL,NULL,'BUY_WATCH',3190.8,3083.83,3315.53,1.166);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-13',69.98,22.83,14.18,8.65,3178.56,3119.5,3142.18,3076.48,41.07,756399.8,1.1124,0.040427,-0.004613,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-13','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-13','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-13','v1-technical',70,15,8,12,10,4,7,NULL,NULL,'BUY_WATCH',3193.8,3088.31,3317.01,1.168);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-14',70.89,24.39,16.22,8.16,3187.32,3124.08,3141.31,3077.37,42.35,759815.4,1.2725,0.036993,0.001754,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-14','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-14','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-14','v1-technical',74,15,4,12,10,8,10,NULL,NULL,'BUY_WATCH',3198.5,3092.84,3325.55,1.202);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-15',66,24.49,17.87,6.61,3191.32,3127.95,3140.57,3078.19,42.76,765702.4,1.3676,0.033623,-0.000846,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-15','golden_cross',8,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","rsi_in_band","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-15','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-15','v1-technical',75,15,8,12,10,8,7,NULL,NULL,'BUY_NOW',3187.9,3096.67,3316.18,1.406);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-16',73.09,27.28,19.76,7.53,3199.3,3134.37,3140.1,3079.17,44.31,780591.35,1.324,0.040988,0.012748,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-16','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-16','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-16','v1-technical',78,15,4,15,10,8,10,NULL,NULL,'BUY_WATCH',3225.5,3136.87,3358.44,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-17',71.35,28.84,21.57,7.27,3205.42,3140.37,3139.95,3080.32,44.13,795331.4,1.362,0.044756,0.014295,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-17','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-17','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-17','v1-technical',80,15,4,12,15,8,10,NULL,NULL,'BUY_WATCH',3221.4,3108.97,3353.8,1.178);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-20',73.04,30.52,23.36,7.16,3212.94,3146.84,3139.63,3081.54,45.15,810952.6,1.3548,0.043532,0.014345,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-20','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-20','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-20','v1-technical',80,15,4,12,15,8,10,NULL,NULL,'BUY_WATCH',3231.4,3115.37,3366.84,1.167);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-21',72.39,31.39,24.97,6.42,3219.24,3152.66,3139.55,3082.67,45.23,823690.8,1.2769,0.038085,0.020892,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-21','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-21','exit',0,'{"met":[]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-21','v1-technical',80,15,4,12,15,8,10,NULL,NULL,'BUY_WATCH',3230,3121.14,3365.69,1.246);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-22',76.2,33.58,26.69,6.89,3232.36,3159.44,3139.64,3083.9,46.56,837283.6,1.2715,0.048772,0.033382,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-22','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-22','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-22','v1-technical',90,20,4,15,15,8,10,NULL,NULL,'BUY_WATCH',3253.5,3160.39,3393.17,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-23',75.67,34.83,28.32,6.51,3237.74,3165.59,3139.97,3085.25,46.29,860730.9,1.3911,0.039936,0.028915,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-23','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-23','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-23','v1-technical',86,20,4,12,15,8,10,NULL,NULL,'BUY_WATCH',3252.4,3133.94,3391.26,1.172);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-24',78.01,36.67,29.99,6.68,3247.1,3172.98,3140.62,3086.6,45.92,888640.35,1.2639,0.050801,0.035191,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-24','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-24','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-24','v1-technical',90,20,4,15,15,8,10,NULL,NULL,'BUY_WATCH',3268.2,3176.37,3405.95,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-27',80,38.9,31.77,7.13,3257.48,3180.45,3141.55,3088.2,46.04,908662.5,1.2445,0.056607,0.043676,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-27','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-27','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-27','v1-technical',90,20,4,15,15,8,10,NULL,NULL,'BUY_WATCH',3283.3,3191.21,3421.43,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-28',80.02,40.21,33.46,6.76,3268.18,3187.33,3142.21,3089.75,45.82,935716.3,1.2146,0.053856,0.041554,3286.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-28','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-28','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-28','v1-technical',83,20,1,12,15,8,10,NULL,NULL,'BUY_WATCH',3283.5,3191.86,3420.96,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-29',80.59,41.12,34.99,6.13,3275.02,3194.75,3143.2,3091.39,44.36,960541.4,1.268,0.050887,0.052906,3287.7,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-29','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-29','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-29','v1-technical',83,20,1,12,15,8,10,NULL,NULL,'BUY_WATCH',3287.7,3198.98,3420.78,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-30',83.68,43.46,36.68,6.77,3287.32,3202.21,3144.44,3093.15,44.38,984928.45,1.225,0.058923,0.063409,3313.9,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-30','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-30','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-30','v1-technical',86,20,1,15,15,8,10,NULL,NULL,'BUY_WATCH',3313.9,3225.14,3447.03,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-07-31',84.39,45.34,38.42,6.93,3297.84,3210.63,3145.94,3094.98,44.99,1005781.2,1.0865,0.049524,0.062554,3320.8,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-31','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-07-31','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-07-31','v1-technical',81,20,1,15,15,4,10,NULL,NULL,'BUY_WATCH',3320.8,3230.81,3455.78,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-03',84.84,46.65,40.06,6.59,3306.22,3219.34,3147.49,3096.92,44.82,1025367.75,1.0089,0.049025,0.06478,3325.2,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-03','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-03','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-03','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3325.2,3235.57,3459.65,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-04',81.95,46.75,41.4,5.35,3313.56,3227.52,3149.19,3098.85,42.16,1038635.8,1.0431,0.052461,0.062974,3325.2,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-04','golden_cross',7,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive","volume_expanding"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-04','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-04','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3320.2,3235.87,3446.69,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-05',81.83,46.28,42.38,3.9,3320.02,3235.18,3150.91,3100.71,41.89,1056628.45,0.9954,0.048013,0.063012,3325.2,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-05','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-05','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-05','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3320,3236.22,3445.67,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-06',82.33,45.67,43.03,2.63,3321.96,3242.95,3152.76,3102.67,39.51,1061125.75,0.9387,0.04332,0.064642,3325.2,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-06','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-06','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-06','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3323.6,3244.58,3442.13,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-07',86.38,47.54,43.93,3.6,3329.72,3250.77,3155.21,3104.85,40.97,1070497.65,0.8891,0.052902,0.078766,3359.6,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-07','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-07','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-07','v1-technical',81,20,1,15,15,4,10,NULL,NULL,'BUY_WATCH',3359.6,3277.65,3482.52,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-10',86.61,48.65,44.88,3.78,3337.08,3258.46,3157.56,3106.98,40.9,1073256.95,0.8354,0.052665,0.082561,3362,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-10','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-10','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-10','v1-technical',81,20,1,15,15,4,10,NULL,NULL,'BUY_WATCH',3362,3280.2,3484.69,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-11',85.24,48.8,45.66,3.14,3345,3266.66,3160.17,3109.18,40.49,1066644.75,0.7825,0.05043,0.084576,3362,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-11','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-11','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-11','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3359.8,3278.82,3481.27,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-12',85.73,48.71,46.27,2.44,3353.84,3274.51,3163.05,3111.47,38.14,1058200.45,0.83,0.055303,0.089161,3364.2,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-12','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-12','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-12','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3364.2,3287.92,3478.62,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-13',86.16,48.39,46.7,1.7,3362.74,3281.81,3165.81,3113.72,38.9,1039305.65,0.6308,0.04421,0.087396,3368.1,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-13','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-13','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-13','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3368.1,3290.29,3484.81,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-14',88.93,49.98,47.35,2.63,3370.42,3290.1,3169.02,3116.2,38.74,1025861.65,0.7939,0.054821,0.102531,3398,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-14','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-14','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-14','v1-technical',78,20,1,15,15,1,10,NULL,NULL,'BUY_WATCH',3398,3320.52,3514.21,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-17',89.51,51.26,48.13,3.12,3379.14,3298.57,3172.49,3118.76,37.81,1005997.35,0.6972,0.053909,0.09968,3405.6,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-17','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-17','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-17','v1-technical',78,20,1,15,15,1,10,NULL,NULL,'BUY_WATCH',3405.6,3329.97,3519.04,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-18',90.09,52.31,48.97,3.34,3389.88,3307.17,3175.97,3121.36,38.37,982469.8,0.5915,0.056811,0.105444,3413.5,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-18','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-18','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-18','v1-technical',78,20,1,15,15,1,10,NULL,NULL,'BUY_WATCH',3413.5,3336.76,3528.61,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-19',90.67,53.2,49.82,3.39,3401.42,3316.53,3179.96,3124.04,38.39,958035.2,0.6011,0.05176,0.109637,3421.9,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-19','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-19','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-19','v1-technical',78,20,1,15,15,1,10,NULL,NULL,'BUY_WATCH',3421.9,3345.13,3537.06,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-20',88.26,53.01,50.45,2.56,3411.46,3324.24,3183.99,3126.65,37.77,933957.75,0.7664,0.051008,0.110487,3421.9,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-20','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-20','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-20','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3418.3,3342.77,3531.6,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-21',81.87,51.48,50.66,0.82,3413.56,3331.73,3187.76,3129.23,38.3,913541.55,0.7825,0.042929,0.112326,3421.9,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-21','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-21','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-21','v1-technical',74,20,1,12,15,1,10,NULL,NULL,'BUY_WATCH',3408.5,3331.91,3523.39,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-24',84.46,51.36,50.8,0.56,3418.34,3339.65,3191.85,3132.01,39.37,894474.55,0.8379,0.044528,0.110122,3429.5,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-24','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-24','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-24','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3429.5,3350.76,3547.61,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-25',80.73,50.18,50.68,-0.49,3420.28,3347.38,3195.85,3134.66,39.69,874238.9,0.8371,0.042546,0.109088,3429.5,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-25','golden_cross',4,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-25','exit',2,'{"met":["rsi_overbought","macd_dead_cross"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-25','v1-technical',65,20,1,2,15,4,10,NULL,NULL,'BUY_WATCH',3423.2,3313.91,3542.26,1.089);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-26',84.08,50.91,50.72,0.18,3426.1,3355.28,3200.22,3137.54,39.98,845882.85,0.7694,0.04967,0.126747,3451,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-26','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-26','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-26','v1-technical',78,20,1,15,15,1,10,NULL,NULL,'BUY_WATCH',3451,3371.04,3570.94,1.5);
INSERT INTO indicators_daily (symbol_id,date,rsi14,macd,macd_signal,macd_hist,sma5,sma25,sma75,sma200,atr14,vol_sma20,vol_ratio,ret20,ret60,hi52,lo52) VALUES ('JP.80580','2026-08-27',84.1,50.91,50.76,0.15,3432.68,3363.23,3204.61,3140.36,41.79,825107.3,0.9588,0.041432,0.118957,3451.2,2854.6);
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-27','golden_cross',6,'{"met":["sma5_above_sma25","sma25_rising","close_above_sma25","close_above_sma75","macd_above_signal","hist_positive"],"crossedToday":false,"qualified":false}');
INSERT INTO signals_daily (symbol_id,date,signal_code,strength,detail) VALUES ('JP.80580','2026-08-27','exit',1,'{"met":["rsi_overbought"]}');
INSERT INTO scores_daily (symbol_id,date,score_version,total,c_trend,c_rsi,c_macd,c_ma,c_volume,c_momentum,c_fundamental,c_news,verdict,entry_px,stop_px,target_px,rr) VALUES ('JP.80580','2026-08-27','v1-technical',78,20,1,12,15,4,10,NULL,NULL,'BUY_WATCH',3451.2,3367.62,3576.56,1.5);

INSERT INTO job_runs (job, target_date, status, started_at, finished_at, rows_written) VALUES ('sample_seed', '2026-08-27', 'ok', '2026-08-27T00:00:00Z', '2026-08-27T00:00:00Z', 5);
INSERT INTO job_runs (job, target_date, status, started_at, finished_at, rows_written) VALUES ('daily_pipeline', '2026-08-27', 'ok', '2026-08-27T10:30:00Z', '2026-08-27T10:35:00Z', 5);
