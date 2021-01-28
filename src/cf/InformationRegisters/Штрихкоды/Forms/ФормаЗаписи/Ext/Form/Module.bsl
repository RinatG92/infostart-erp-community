﻿&НаКлиенте
Процедура СформироватьШтрихКод(Команда)
	Если ЗначениеЗаполнено(Запись.Штрихкод) Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработчикОповещения_СформироватьШтрихКод", ЭтотОбъект), "Сформировать новый штрихкод для выбранной строки?", РежимДиалогаВопрос.ДаНет, 20, КодВозвратаДиалога.Да, "Подтверждение действия", КодВозвратаДиалога.Нет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОповещения_СформироватьШтрихКод(Параметр1, Параметр2) Экспорт
	Если Параметр1=КодВозвратаДиалога.Нет Тогда Возврат; КонецЕсли;
	Запись.Штрихкод=СформироватьШтрихКодАвтоматтически();
КонецПроцедуры 

&НаСервере
Функция КонтрольныйСимволEAN(ШтрихКод, Тип) Экспорт
	Четн=0; Нечетн=0;

	КоличествоИтераций = ?(Тип = 13, 6, 4);

	Для Индекс = 1 По КоличествоИтераций Цикл
		Если (Тип = 8) и (Индекс = КоличествоИтераций) Тогда
		Иначе
			Четн   = Четн   + Сред(ШтрихКод, 2 * Индекс, 1);
		КонецЕсли;
		Нечетн = Нечетн + Сред(ШтрихКод, 2 * Индекс - 1, 1);
	КонецЦикла;

	Если Тип = 13 Тогда
		Четн = Четн * 3;
	Иначе
		Нечетн = Нечетн * 3;
	КонецЕсли;

	КонтЦифра = 10 - (Четн + Нечетн) % 10;

	Возврат ?(КонтЦифра = 10, "0", Строка(КонтЦифра));
КонецФункции

&НаСервере
Функция СформироватьШтрихКодАвтоматтически(Знач ПрефиксШтучногоТовара = Неопределено, Знач ПрефиксВнутреннегоШтрихкода = Неопределено) Экспорт
	Если ПрефиксШтучногоТовара = Неопределено Тогда
		ПрефиксШтучногоТовара = СокрЛП(Константы.ПрефиксШтучногоТовара.Получить());
	КонецЕсли;
	Если ПрефиксВнутреннегоШтрихкода = Неопределено Тогда
		ПрефиксВнутреннегоШтрихкода = Константы.ПрефиксВнутреннегоШтрихкода.Получить();
	КонецЕсли;

	ПрефиксШтучногоТовара = ?(ПустаяСтрока(ПрефиксШтучногоТовара), "0", ПрефиксШтучногоТовара);
	ПрефиксВнутреннегоШтрихкода = Формат(ПрефиксВнутреннегоШтрихкода, "ЧЦ=2; ЧН=; ЧВН=");

	Запрос=Новый Запрос("
	|ВЫБРАТЬ
	|	МАКСИМУМ(ПОДСТРОКА(ИсточникДанных.Штрихкод, 5, 8)) КАК Код
	|ИЗ
	|	РегистрСведений.ШтрихКоды КАК ИсточникДанных
	|ГДЕ
	|	ИсточникДанных.ТипШтрихкода = ЗНАЧЕНИЕ(ПланВидовХарактеристик.ТипыШтрихкодов.EAN13)
	|	И ИсточникДанных.Штрихкод ПОДОБНО ""2" + ПрефиксШтучногоТовара + ПрефиксВнутреннегоШтрихкода + "[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]""
	|");
	Выборка=Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	ТекКод=?(Выборка.Код=NULL, 1, Мин(Число(Выборка.Код)+1, 99999999));

	Штрихкод="2"+ПрефиксШтучногоТовара+ПрефиксВнутреннегоШтрихкода+Формат(ТекКод, "ЧЦ=8; ЧВН=; ЧГ=");
	Штрихкод=Штрихкод+КонтрольныйСимволEAN(ШтрихКод, 13);

	Возврат Штрихкод;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если Источник="ПодключаемоеОборудование" И ВводДоступен() Тогда
		Если ИмяСобытия="ScanData" Тогда
			Запись.ШтрихКод=?(Параметр[1]=Неопределено, Параметр[0], Параметр[1][1]);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЭтаФорма.ОписаниеОповещенияОЗакрытии=Неопределено Тогда
		ЭтаФорма.ОписаниеОповещенияОЗакрытии.ДополнительныеПараметры.Вставить("ХарактеристикаНоменклатуры", Запись.ХарактеристикаНоменклатуры);
	КонецЕсли;	
КонецПроцедуры
