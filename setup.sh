#!/bin/sh


install_driver(){
	echo "Переустановить драйвер ? (y/n):"
	read yesno;
	if [[ $yesno == "y" ]]
	then
		cd ./dasd-1.4.2
		sudo ./install.rc
		cd ..
	else
		echo "Ну нет. Так нет."
	fi
	
}


copy_new_files(){
	# вариант копирования если есть предыдущая установка
	if [[ $1 == "1" ]] 
	then
		echo "Создать резервную копию старой установки\" ? (y/n):"
		read yesno
		if [[ $yesno == "y" ]]
		then
			echo "Копируем файлы в архив"
			tar -cvf $program_files$main_folder$postfix_installation.tar $program_files$main_folder
			tar -rvf $program_files$main_folder$postfix_installation.tar $config_path
			tar -rvf $program_files$main_folder$postfix_installation.tar $root_config_path
			chown -R $name_user:$name_user $program_files$main_folder$postfix_installation.tar
			
		else
			echo "Ну нет. тak нет."
		fi
		
		echo "Копирование файлов в $program_files$main_folder"
		# копируем вайлы для новой установки
		# варианты копирования исполняемых файлов для разных установок в рабочую папку
		case $var1 in
		"-1") # gpr1
			cp -p asku-gui $program_files$main_folder
			cp -p asku-svc $program_files$main_folder
		;;
		"-2") # gpr2
			cp -p asku-gui $program_files$main_folder
			cp -p asku-svc $program_files$main_folder
		;;
		"-3") # trm
			cp -p asku-gui $program_files$main_folder
			cp -p asku-avt $program_files$main_folder
			cp -p asku-pwm $program_files$main_folder
			cp -p asku-pkf $program_files$main_folder
		;;
		"-4")# rmo
			cp -p asku-gui $program_files$main_folder
		;;
		esac
		
		# Скопируем папку init.d в $program_files$main_folder чтобы потом можно было восстановить установку из архива
		cp -r -p ./etc/init.d $program_files$main_folder
		
		echo "Обновить levels\" ? (y/n):"
		read yesno
		if [[ $yesno == "y" ]]
		then
			echo "Копируем файлы"
			cp -p ./levels $program_files$main_folder
		else
			echo "Ну нет. тak нет."
		fi
		
		echo "Обновить media, tables-A(b), scheme\" ? (y/n):"
		read yesno
		if [[ $yesno == "y" ]]
		then
			echo "Копируем файлы"
			
			cp -r -p ./media $program_files$main_folder
			cp -r -p ./tables-A $program_files$main_folder
			cp -r -p ./tables-B $program_files$main_folder
			cp -r -p ./scheme $program_files$main_folder
		else
			echo "Ну нет. тak нет."
		fi
		
		echo "Обновить config в $program_files$main_folder\" ? (y/n):"
		read yesno
		if [[ $yesno == "y" ]]
		then
			echo "Копируем файлы"
			
			cp -r -p ./config $program_files$main_folder
		else
			echo "Ну нет. тak нет."
		fi
		
		# Выполним рекурсивное назначение владельца для всех скопированных файлов
		chown -R $name_user:$name_user $program_files$main_folder
	# вариант если нет предыдущей установки
	elif [[ $1 == "11" ]] 
	then
		echo "Копирование файлов в $program_files$main_folder"
		# варианты копирования исполняемых файлов для разных установок в рабочую папку
		case $var1 in
		"-1") # gpr1
			cp -p asku-gui $program_files$main_folder
			cp -p asku-svc $program_files$main_folder
		;;
		"-2") # gpr2
			cp -p asku-gui $program_files$main_folder
			cp -p asku-svc $program_files$main_folder
		;;
		"-3") # trm
			cp -p asku-gui $program_files$main_folder
			cp -p asku-avt $program_files$main_folder
			cp -p asku-pwm $program_files$main_folder
			cp -p asku-pkf $program_files$main_folder
		;;
		"-4")# rmo
			cp -p asku-gui $program_files$main_folder
		;;
		esac
		# Скопируем папку init.d в $program_files$main_folder чтобы потом можно было восстановить установку из архива
		cp -r -p ./etc/init.d $program_files$main_folder
		# Скопируем остальные файлы
		cp -r -p ./levels $program_files$main_folder
		cp -r -p ./media $program_files$main_folder
		cp -r -p ./phase $program_files$main_folder
		cp -r -p ./log_files $program_files$main_folder
		cp -r -p ./config $program_files$main_folder
		cp -r -p ./tables-A $program_files$main_folder
		cp -r -p ./tables-B $program_files$main_folder
		cp -r -p ./scheme $program_files$main_folder
		
		# Выполним рекурсивное назначение владельца для всех скопированных файлов
		chown -R $name_user:$name_user $program_files$main_folder
	# копирование config файлов в /home/$name_user/.config/asku
	elif [[ $1 == "2" ]]
	then
		case $var1 in
		"-1")
			cp -p ./home/asku/asku-gui.conf.gpr1 $config_path/asku-gui.conf
			chown -R $name_user:$name_user $config_path
		;;
		"-2")
			cp -p ./home/asku/asku-gui.conf.gpr2 $config_path/asku-gui.conf
			chown -R $name_user:$name_user $config_path
		;;
		"-3")
			cp -p ./home/asku/asku-gui.conf.trm $config_path/asku-gui.conf
			chown -R $name_user:$name_user $config_path
		;;
		"-4")
			cp -p ./home/asku/asku-gui.conf.rmo $config_path/asku-gui.conf
			chown -R $name_user:$name_user $config_path
		;;
		esac
	# копирование config файлов в /root/.config/asku
	elif [[ $1 == "3" ]]
	then
		case $var1 in
		"-1")
			cp -p ./home/asku/asku-svc.conf.gpr1 $root_config_path/asku-svc.conf
			chown -R root:root $root_config_path
		;;
		"-2")
			cp -p ./home/asku/asku-svc.conf.gpr2 $root_config_path/asku-svc.conf
			chown -R root:root $root_config_path
		;;
		"-3")
			cp -p ./home/asku/asku-pwm.conf.trm $root_config_path/asku-pwm.conf
			cp -p ./home/asku/asku-avt.conf.trm $root_config_path/asku-avt.conf
			cp -p ./home/asku/asku-pkf.conf.trm $root_config_path/asku-pkf.conf
			chown -R root:root $root_config_path
		;;
		esac
	fi
}


install_autoboot_servises(){
	if [[ ("$var1" == "-1") || ("$var1" == "-2") ]]
	then
		cp -r -p .$autorun_path/asku-svc $autorun_path/asku-svc
		chown root:root $autorun_path/asku-svc
		chmod 0755 $autorun_path/asku-svc
		sudo update-rc.d asku-svc defaults
	elif [[ "$var1" == "-3" ]]
	then
		cp -r -p .$autorun_path/asku-pwm $autorun_path/asku-pwm
		chown root:root $autorun_path/asku-pwm
		chmod 0755 $autorun_path/asku-pwm
		sudo update-rc.d asku-pwm defaults

		cp -r -p .$autorun_path/asku-avt $autorun_path/asku-avt
		chown root:root $autorun_path/asku-avt
		chmod 0755 $autorun_path/asku-avt
		sudo update-rc.d asku-avt defaults

		cp -r -p .$autorun_path/asku-pkf $autorun_path/asku-pkf
		chown root:root $autorun_path/asku-pkf
		chmod 0755 $autorun_path/asku-pkf
		sudo update-rc.d asku-pkf defaults
	fi
}


create_folders(){
	
	if [[ !(-e $program_files$main_folder) ]]
	then
		echo "Создаём $program_files$main_folder. Записываем все файлы."
		mkdir $program_files$main_folder
		copy_new_files "11"
		echo "Укажите литеру станции (a/b) ?"
		read litera
		if [[ $litera == "a" ]]
		then
			echo "Установка для литеры А"
			ln -s $program_files$main_folder/tables-A $program_files$main_folder/tables
		elif [[ $litera == "b" ]]
		then
			echo "Установка для литеры B"
			ln -s $program_files$main_folder/tables-B $program_files$main_folder/tables
		else
			echo "Неизвестная литера! Будет установлена версия для литеры А"
			ln -s $program_files$main_folder/tables-A $program_files$main_folder/tables
		fi
	else
		# остановим службы и процессы которые могут мешать устанвке
		killall -w gprstart
		killall -w asku-gui
		killall -w voi
		sudo service asku-svc stop
		sudo service asku-avt stop
		sudo service asku-pkf stop
		sudo service asku-pwm stop
		echo "$program_files$main_folder существует. Делаем переустановку."
		copy_new_files "1"
	fi
	if [[ !(-e $config_path) ]]
	then
		mkdir $config_path
		echo "$config_path создана"
		copy_new_files "2"
	else
		echo "Обновить config-файлы в \"$config_path\" ? (y/n):"
		read yesno;
		if [[ $yesno == "y" ]]
		then
			copy_new_files "2"
		else
			echo "Ну нет. Так нет."
		fi
	fi

	if [[ !(-e $root_config_path) ]]
	then
		mkdir $root_config_path
		echo "$root_config_path создана"
		copy_new_files "3"
	else
		echo "Обновить config-файлы в \"$root_config_path\" ? (y/n):"
		read yesno;
		if [[ $yesno == "y" ]]
		then
			copy_new_files "3"
		else
			echo "Ну нет. Так нет."
		fi
	fi
	echo "Обновить файлы автозапуска сервисов в \"$autorun_path\" ? (y/n):"
	read yesno;
	if [[ $yesno == "y" ]]
	then
		install_autoboot_servises
	else
		echo "Ну нет. Так нет."
	fi
}


uninstall_program(){
	if [[ $1 == "y" ]]
	then
		echo "Остановка процессов"
		killall -w gprstart
		killall -w asku-gui
		killall -w voi
		echo "Удаление предыдущей установки, конфигурации и лог файлов"
		rm -r $config_path
		echo "$config_path удалена"
		rm -r $root_config_path
		echo "$root_config_path удалена"
		rm -r $program_files$main_folder
		echo "$program_files$main_folder удалена"
		echo "отключение автозапуска"
		sudo update-rc.d -f asku-svc remove
		sudo update-rc.d -f asku-avt remove
		sudo update-rc.d -f asku-pkf remove
		sudo update-rc.d -f asku-pvm remove
		echo "остановка служб"
		service asku-svc stop
		service asku-avt stop
		service asku-pkf stop
		service asku-pwm stop
		echo "удаление драйвера"
		cd ./dasd-1.4.2
		sudo ./uninstall.rc
		cd ..
		echo "удаление файлов автозапуска"
		rm -v $autorun_path/asku-svc
		rm -v $autorun_path/asku-pwm
		rm -v $autorun_path/asku-pkf
		rm -v $autorun_path/asku-avt
		echo "Усё!"
	else
		echo "Ну нет. так нет. Удаление только установки."
		echo "Остановка процессов"
		killall -w gprstart
		killall -w asku-gui
		killall -w voi
		echo "отключение автозапуска"
		update-rc.d -f asku-svc remove
		update-rc.d -f asku-avt remove
		update-rc.d -f asku-pkf remove
		update-rc.d -f asku-pvm remove
		
		echo "остановка служб"
		service asku-svc stop
		service asku-avt stop
		service asku-pkf stop
		service asku-pwm stop
		
		rm -v $program_files$main_folder/asku-gui
		rm -v $program_files$main_folder/asku-svc
		rm -v $program_files$main_folder/asku-pwm
		rm -v $program_files$main_folder/asku-pkf
		rm -v $program_files$main_folder/asku-avt
		rm -r -v $program_files$main_folder/media
		rm -r -v $program_files$main_folder/levels
		echo "$program_files удалена"
		echo "удаление драйвера"
		cd ./dasd-1.4.2
		sudo ./uninstall.rc
		cd ..
		echo "удаление файлов автозапуска"
		rm -v $autorun_path/asku-svc
		rm -v $autorun_path/asku-pwm
		rm -v $autorun_path/asku-pkf
		rm -v $autorun_path/asku-avt
		echo "Усё!"
	fi
}

echo
echo "------------------------------------------------------------"
echo "Добро пожаловать в мастер установки ПО АСКУ \"Наблюдатель\"!"

var1=$1
name_user=$2

if [[ -z $name_user ]]
then
	name_user="bobreg"   # а должен быть rlp
fi


#---пользователь кто запустил скрипт---
launch_user=`whoami`
if [[ $launch_user != "root" ]]
then
	echo "Необходимо запустить устанощик под суперпользователем!"
	echo "Установка прервана!"
	exit
fi

#--- основные пути---
program_files=/opt
config_path=/home/$name_user/.config/asku
root_config_path=/root/.config/asku
autorun_path=/etc/init.d

#---главная папка---
main_folder=/amcs-observer

if [[ -z $var1  ]]
then
	echo "Нет параметра запуска!"
	echo "\"-1\" - установка для ГПР1"
	echo "\"-2\" - установка для ГПР2"
	echo "\"-3\" - установка для ТРМ"
	echo "\"-4\" - установка для РМО"
	echo "\"-5\" - удаление предыдущей установки"
	exit
else
	postfix_installation=`date +"%F_%H_%M"`
	echo "$postfix_installation"
	case $var1 in
	"-1")
		echo "Yстановка для ГПР1"
		create_folders
		install_driver
	;;
	"-2")
		echo "Yстановка для ГПР2"
		create_folders
		install_driver
	;;
	"-3")
		echo "Yстановка для ТРМ"
		create_folders
	;;
	"-4")
		echo "Yстановка для РМО"
		create_folders
	;;
	"-5")
		echo "Тут мы удаляем всё, но не удаляем пока"
	;;
	"-55")
		echo "Удалить файлы конфигурации и лог файлы? (y/n):"
		read yesno;
		uninstall_program $yesno
	;;
	*)
		echo "Неизвестный параметр. Установка прервана!"
		exit
	;;
	esac
fi
echo "---------------Благодарю за внимание--------------------"


