# checker spec for 1420 (see lib/engine.sh)
SEEDS=1
ARGS=('web_2024-08-09.tgz db-main_2023-12-31.tar.gz' 'x_2024-13-01.tgz y_2024-00-10.tgz z_2024-02-32.tar.gz w_2024-02-00.tgz v_2024-09-30.tgz' '"bad name_2024-01-01.tgz" a_2024-1-01.tgz a_2024-01-01.tar a_2024-01-01.tar.gz.bak _2024-01-01.tgz app_v2_2024-05-05.tgz A-1_1999-01-08.tar.gz' '')
extra_check() { must_use BASH_REMATCH; }
