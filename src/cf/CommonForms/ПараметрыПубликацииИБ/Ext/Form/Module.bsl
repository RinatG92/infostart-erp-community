﻿&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	Если Команда.Имя="Записать" Тогда
		Записать(); ЭтаФорма.Закрыть();
	КонецЕсли; 
КонецПроцедуры

&НаСервере
Процедура Записать()
	СтруктураПараметров=Новый Структура("Сервер,Порт,База");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭтаФорма);
	Константы.ПараметрыПубликацииИБ.Установить(Новый ХранилищеЗначения(СтруктураПараметров, Новый СжатиеДанных(9)));	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СтруктураПараметров=УправлениеКонфигурациейСервер.ПараметрыПубликацииИБ();
	Если ТипЗнч(СтруктураПараметров)=Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(ЭтаФорма, СтруктураПараметров);
	КонецЕсли;
КонецПроцедуры