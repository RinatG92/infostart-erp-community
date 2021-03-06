﻿&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	ДинамическиеСпискиКлиент.ВыполнитьДействие(Команда.Имя, ЭтаФорма);
	Если Команда.Имя="ПроверкаПоДаннымСайтаФНС" Тогда
		ОткрытьФорму("Обработка.ПроверкаИНН.Форма.ПроверкаПоДаннымСайтаФНС",,ЭтаФорма,УникальныйИдентификатор);
	КонецЕсли;	 
КонецПроцедуры

&НаКлиенте
Процедура Страницы_ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	//тпСсылка_Обновить(Элементы.ДинамическийСписок.ТекущаяСтрока);
	тпСсылка_Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьКнопкиОтключенияОтбора()
	//ДоступностьЭлемента=Ложь;
	//Для каждого СтрокаКоллекции Из ДинамическийСписок.Отбор.Элементы Цикл
	//	Если СтрокаКоллекции.РежимОтображения=РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	Если СтрокаКоллекции.Использование Тогда ДоступностьЭлемента=Истина; Прервать; КонецЕсли;
	//КонецЦикла;
	//Элементы.ДинамическийСписокОтключитьОтбор.Доступность=ДоступностьЭлемента;
КонецПроцедуры

&НаКлиенте
Процедура тпСсылка_Обновить() //КонтрагентСсылка=Неопределено
	КонтрагентСсылка=Элементы.ДинамическийСписок.ТекущаяСтрока; //****
	стрИмя=Элементы.Страницы.ТекущаяСтраница.Имя;
	Если стрИмя="СтраницаИнформация" Тогда
		тпКонтактнаяИнформация_УстановитьОтбор(КонтрагентСсылка);
		
	ИначеЕсли стрИмя="СтраницаДокументы" Тогда
		тпДокументы_Отбор(КонтрагентСсылка);
		
	ИначеЕсли стрИмя="СтраницаДоговоры" Тогда
		тпДоговоры_Отбор(КонтрагентСсылка);
		
	ИначеЕсли стрИмя="СтраницаВзаиморасчеты" Тогда
		тпВзаиморасчеты_Отбор(КонтрагентСсылка);
		
	ИначеЕсли стрИмя="СтраницаКонтактныеЛица" Тогда
		тпКонтактныеЛица_Отбор(КонтрагентСсылка);		
	КонецЕсли;	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Взаиморасчеты"

&НаСервере
Процедура тпВзаиморасчеты_Отбор(Ссылка)
	дзСсылка=РеквизитФормыВЗначение("тпВзаиморасчеты");
	дзСсылка.Строки.Очистить(); ДолгКонтрагента=0; ДолгФирмы=0;
	
	Если НЕ Ссылка=Неопределено И НЕ Ссылка.ЭтоГруппа Тогда
		Запрос=Новый Запрос;
		Запрос.УстановитьПараметр("Контрагент", Ссылка);
		Запрос.УстановитьПараметр("НаДату", ТекущаяДата());
		Запрос.Текст="
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.Организация) КАК Организация,
		|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.ДоговорКонтрагента) КАК Договор,
		|	СУММА(ВЫБОР
		|			КОГДА ИсточникДанных.СуммаБухОстаток > 0
		|				ТОГДА ИсточникДанных.СуммаБухОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ДолгКонтрагента,
		|	СУММА(ВЫБОР
		|			КОГДА ИсточникДанных.СуммаБухОстаток < 0
		|				ТОГДА -ИсточникДанных.СуммаБухОстаток
		|			ИНАЧЕ 0
		|		КОНЕЦ) КАК ДолгФирмы
		|ИЗ
		|	РегистрНакопления.ВзаиморасчетыСКонтрагентами.Остатки(&НаДату, Контрагент = &Контрагент) КАК ИсточникДанных
		|
		|СГРУППИРОВАТЬ ПО
		|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.Организация),
		|	ПРЕДСТАВЛЕНИЕ(ИсточникДанных.ДоговорКонтрагента)
		|ИТОГИ ПО
		|	Организация,
		|	Договор
		|";
		Выборка1=Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Организация");
		Пока Выборка1.Следующий() Цикл
			НоваяСтрока1=дзСсылка.Строки.Добавить();
			НоваяСтрока1.Представление=Выборка1.Организация;
			ЗаполнитьЗначенияСвойств(НоваяСтрока1, Выборка1);
			ДолгФирмы=ДолгФирмы+Выборка1.ДолгФирмы;
			ДолгКонтрагента=ДолгКонтрагента+Выборка1.ДолгКонтрагента;
			
			Выборка2=Выборка1.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Договор");
			Пока Выборка2.Следующий() Цикл
				НоваяСтрока2=НоваяСтрока1.Строки.Добавить();
				НоваяСтрока2.Представление=Выборка2.Договор;
				ЗаполнитьЗначенияСвойств(НоваяСтрока2, Выборка2);
			КонецЦикла;
		КонецЦикла;
		Если Не дзСсылка.Строки.Количество()=0 Тогда
			НоваяСтрока=дзСсылка.Строки.Добавить();
			НоваяСтрока.Представление="Итого";
			Если ДолгКонтрагента > ДолгФирмы Тогда
				НоваяСтрока.ДолгКонтрагента=ДолгКонтрагента-ДолгФирмы;
			ИначеЕсли ДолгКонтрагента < ДолгФирмы Тогда
				НоваяСтрока.ДолгФирмы=ДолгФирмы-ДолгКонтрагента;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	ЗначениеВДанныеФормы(дзСсылка, тпВзаиморасчеты);	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Договоры"

&НаСервере
Процедура тпКонтактныеЛица_Отбор(Ссылка=Неопределено)
	Если тпКонтактныеЛица.КомпоновщикНастроек.Настройки.Отбор.Элементы.Количество()=0 Тогда Возврат; КонецЕсли;
	
	Если Ссылка=Неопределено Или Ссылка.ЭтоГруппа Тогда
		Ссылка=ПредопределенноеЗначение("Справочник.КонтактныеЛицаКонтрагентов.ПустаяСсылка");
	КонецЕсли;
	тпКонтактныеЛица.КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение=Ссылка;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Договоры"

&НаСервере
Процедура тпДоговоры_Отбор(Ссылка=Неопределено)
	Если тпДоговоры.КомпоновщикНастроек.Настройки.Отбор.Элементы.Количество()=0 Тогда Возврат; КонецЕсли;

	Если Ссылка=Неопределено Или Ссылка.ЭтоГруппа Тогда
		Ссылка=ПредопределенноеЗначение("Справочник.ДоговорыКонтрагентов.ПустаяСсылка");
	КонецЕсли;	
	тпДоговоры.КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение=Ссылка;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Журнал документов"

&НаСервере
Процедура тпДокументы_Отбор(Ссылка=Неопределено)
	Если тпДокументы.КомпоновщикНастроек.Настройки.Отбор.Элементы.Количество()=0 Тогда Возврат; КонецЕсли;

	Если Ссылка=Неопределено Или Ссылка.ЭтоГруппа Тогда
		Ссылка=ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;
	тпДокументы.КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение=Ссылка;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Контактная информация"

&НаСервере
Процедура тпКонтактнаяИнформация_УстановитьОтбор(Ссылка=Неопределено)
	Если Ссылка=Неопределено Или Ссылка.ЭтоГруппа Тогда
		Ссылка=ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;
	ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(тпКонтактнаяИнформация, "Объект", Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура тпКонтактнаяИнформация_ПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Ссылка=Элементы.ДинамическийСписок.ТекущаяСтрока;
	Если Ссылка=Неопределено Или Ссылка.ЭтоГруппа Тогда
		Ссылка=ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка");
	КонецЕсли;
	КонтактнаяИнформацияКлиент.ПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр, ЭтаФорма, Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура тпКонтактнаяИнформация_ПередНачаломИзменения(Элемент, Отказ)
	КонтактнаяИнформацияКлиент.ПередНачаломИзменения(Элемент, Отказ, ЭтаФорма);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Динамический список"

&НаКлиенте
Процедура ДинамическийСписок_Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ДинамическиеСпискиКлиент.Выбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка, ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписок_ПриАктивизацииСтроки(Элемент)
	//*** тпСсылка_Обновить(Элемент.ТекущаяСтрока);
	ПодключитьОбработчикОжидания("тпСсылка_Обновить", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДинамическийСписок_ВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	Если ТипЗнч(Значение)=Тип("Массив") Тогда
		ОповеститьОВыборе(Значение[0]);
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДинамическиеСпискиСервер.НастройкаПоПравилам(ДинамическийСписок, ЭтаФорма);
	Элементы.ДинамическийСписок.РежимВыбора=Параметры.РежимВыбора;
	
	Если Параметры.РежимВыбора Тогда
		Элементы.ДинамическийСписок.Отображение=ОтображениеТаблицы.Список;
	КонецЕсли; 

	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок=Параметры.Заголовок;
	КонецЕсли;
	тпКонтактнаяИнформация_УстановитьОтбор();
	тпДокументы_Отбор();
	тпДоговоры_Отбор();
	тпКонтактныеЛица_Отбор();	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ДоступностьКнопкиОтключенияОтбора();
	ДинамическиеСпискиКлиент.ПриОткрытии(Отказ, ДинамическийСписок, ЭтаФорма);
КонецПроцедуры
