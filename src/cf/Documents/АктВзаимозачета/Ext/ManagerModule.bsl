﻿////////////////////////////////////////////////////////////////////////////////
//Управление печатными формами

Процедура СтруктураПечатныхФорм(Структура) Экспорт
	Структура.Вставить("АктВзаимозачета", "Акт взаимозачета");
	Структура.Вставить("УведомлениеОЗачете", "Уведомление о зачете");
	Структура.Вставить("БухгалтерскаяСправка", "Бухгалтерская справка");	
КонецПроцедуры

Функция ИнициализацияМакета(СтруктураПараметров, стрМакет)
	Если СтруктураПараметров.Свойство("Макет") Тогда
		Возврат СтруктураПараметров.Макет;
	КонецЕсли;
	Макет=СтруктураПараметров.МакетШаблон;
	Если Макет=Неопределено Тогда
		Если Метаданные.ОбщиеМакеты.Найти(стрМакет)=Неопределено Тогда
			Макет=ПолучитьМакет(стрМакет);
		Иначе
			Макет=ПолучитьОбщийМакет(стрМакет);
		КонецЕсли;
	КонецЕсли;
	Возврат Макет;
КонецФункции

Функция ПолучитьДанныеДокумента(СсылкаНаОбъект)
	стрРеквизиты="";
	Для каждого мдРеквизит Из СсылкаНаОбъект.Метаданные().Реквизиты Цикл
		стрРеквизиты=стрРеквизиты+","+Символы.ПС+мдРеквизит.Имя;
	КонецЦикла;	

	Запрос=Новый ПостроительЗапроса;
	Запрос.Параметры.Вставить("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст="
	|ВЫБРАТЬ
	|	Дата,
	|	Номер,
	|	Проведен,
	|	Организация.НаименованиеПолное Как ОрганизацияНаименованиеПолное,
	|	КонтрагентДебитор.НаименованиеПолное Как КонтрагентДебиторНаименованиеПолное,
	|	КонтрагентКредитор.НаименованиеПолное Как КонтрагентКредиторНаименованиеПолное
	|	"+стрРеквизиты+",
	|	ДолгКредитора Как ДолгКредитора,
	|	ДолгДебитора Как ДолгДебитора
	|ИЗ
	|	Документ.АктВзаимозачета КАК ИсточникДанных
	|ГДЕ
	|	ИсточникДанных.Ссылка = &ТекущийДокумент
	|";
	
	#Если НаСервере Тогда
	Запрос.Выполнить();
	#КонецЕсли

	Возврат Запрос.Результат.Выгрузить();
КонецФункции 	

Функция ПолучитьДанныеДокумента1(СсылкаНаОбъект)
	стрРеквизиты="";
	Для каждого мдРеквизит Из СсылкаНаОбъект.Метаданные().Реквизиты Цикл
		стрРеквизиты=стрРеквизиты+","+Символы.ПС+мдРеквизит.Имя;
	КонецЦикла;	

	Запрос=Новый ПостроительЗапроса;
	Запрос.Параметры.Вставить("ТекущийДокумент", СсылкаНаОбъект);
	Запрос.Текст="
	|ВЫБРАТЬ
	|	Дата,
	|	Номер,
	|	Проведен,
	|	Организация.НаименованиеПолное Как ОрганизацияНаименованиеПолное,
	|	КонтрагентДебитор.НаименованиеПолное Как КонтрагентДебиторНаименованиеПолное,
	|	КонтрагентКредитор.НаименованиеПолное Как КонтрагентКредиторНаименованиеПолное
	|	"+стрРеквизиты+",
	|	ДолгКредитора Как ДолгКредитора,
	|	ДолгДебитора Как ДолгДебитора
	|ИЗ
	|	Документ.АктВзаимозачета КАК ИсточникДанных
	|ГДЕ
	|	ИсточникДанных.Ссылка = &ТекущийДокумент
	|";
	
	#Если НаСервере Тогда
	Запрос.Выполнить();
	#КонецЕсли
	РеквизитыШапки=Запрос.Результат.Выбрать();
	РеквизитыШапки.Следующий();
	Возврат РеквизитыШапки;
КонецФункции 	

Функция Печать_АктВзаимозачета(СтруктураПараметров)
	ДанныеДокумента=ПолучитьДанныеДокумента1(СтруктураПараметров.СсылкаНаОбъект);
	
	ТабДокумент=Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктВзаимозачета_АктВзаимозачета";
	
	Макет=ИнициализацияМакета(СтруктураПараметров, "АктВзаимозачета");
	
	ОбластьМакета=Макет.ПолучитьОбласть("Шапка");
	ОбластьМакета.Параметры.Номер=ДанныеДокумента.Номер;
	ОбластьМакета.Параметры.Дата=ДанныеДокумента.Дата;
	ОбластьМакета.Параметры.Организация=ДанныеДокумента.ОрганизацияНаименованиеПолное;
	Руководители = ПечатныеФормыСервер.ОтветственныеЛицаОрганизации(ДанныеДокумента.Организация, ДанныеДокумента.Дата, СтруктураПараметров.СсылкаНаОбъект);
	ОбластьМакета.Параметры.Директор=Руководители.Руководитель;
	ТабДокумент.Вывести(ОбластьМакета);
	
	АктТрехсторонний=?((НЕ ДанныеДокумента.КонтрагентКредитор.Пустая()) И (НЕ ДанныеДокумента.КонтрагентДебитор.Пустая()) И (ДанныеДокумента.КонтрагентКредитор<>ДанныеДокумента.КонтрагентДебитор),Истина, Ложь);
	НомерСтороны="2";
	Если АктТрехсторонний Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаКлиент");
		ОбластьМакета.Параметры.Клиент=ДанныеДокумента.КонтрагентДебиторНаименованиеПолное;
		ОбластьМакета.Параметры.НомерСтороны=НомерСтороны;
		ТабДокумент.Вывести(ОбластьМакета);
		НомерСтороны="3";
	КонецЕсли;	
	ОбластьМакета=Макет.ПолучитьОбласть("ШапкаКлиент");
	ОбластьМакета.Параметры.Клиент=ДанныеДокумента.КонтрагентКредиторНаименованиеПолное;
	ОбластьМакета.Параметры.НомерСтороны=НомерСтороны;
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета=Макет.ПолучитьОбласть("Раздел1");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета=Макет.ПолучитьОбласть("ШапкаТЧ");
	ТабДокумент.Вывести(ОбластьМакета);
	ИтогоСуммаДокумента=0; ИтогоСуммаЗачета=0; ИтогоСуммаНДС=0;
	ДолгДебитора=ДанныеДокумента.ДолгДебитора.Выгрузить();
	Для Каждого СтрокаПродажи ИЗ ДолгДебитора Цикл
		ОбластьМакета=Макет.ПолучитьОбласть("СтрокаТЧ");
		ОбластьМакета.Параметры.стрДокумент=?(ЗначениеЗаполнено(СтрокаПродажи.ДокументРасчетовСКонтрагентом),Строка(СтрокаПродажи.ДокументРасчетовСКонтрагентом)+" по договору "+Строка(СтрокаПродажи.ДоговорКонтрагента),СтрокаПродажи.ДоговорКонтрагента);
		СуммаДокумента=?(ЗначениеЗаполнено(СтрокаПродажи.ДокументРасчетовСКонтрагентом), СтрокаПродажи.ДокументРасчетовСКонтрагентом.СуммаДокумента, СтрокаПродажи.СуммаРегл);
		ОбластьМакета.Параметры.СуммаДокумента=СуммаДокумента;
		ОбластьМакета.Параметры.СуммаЗачета=СтрокаПродажи.СуммаРегл;
		ОбластьМакета.Параметры.СуммаНДС=СтрокаПродажи.СуммаНДС;
		ИтогоСуммаДокумента=ИтогоСуммаДокумента+СуммаДокумента;
		ИтогоСуммаЗачета=ИтогоСуммаЗачета+СтрокаПродажи.СуммаРегл;
		ИтогоСуммаНДС=ИтогоСуммаНДС+СтрокаПродажи.СуммаНДС;
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	ОбластьМакета=Макет.ПолучитьОбласть("ПодвалТЧ");
	ОбластьМакета.Параметры.ИтогоСуммаДокумента=ИтогоСуммаДокумента;
	ОбластьМакета.Параметры.ИтогоСуммаЗачетаПрописью=ОбщегоНазначения.СформироватьСуммуПрописью(ИтогоСуммаЗачета, МодульВалютногоУчета.ПолучитьВалюту("Бух"));
	ОбластьМакета.Параметры.ИтогоСуммаЗачета=ИтогоСуммаЗачета;
	ОбластьМакета.Параметры.ИтогоСуммаНДС=ИтогоСуммаНДС;
	ТабДокумент.Вывести(ОбластьМакета);
	
	Если АктТрехсторонний Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("СтрокаПустая");
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
	
	ОбластьМакета = Макет.ПолучитьОбласть("СтрокаСторона");
	ОбластьМакета.Параметры.НомерСтороны=НомерСтороны;
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТЧ");
	ТабДокумент.Вывести(ОбластьМакета);
	ИтогоСуммаДокумента=0; ИтогоСуммаЗачета=0; ИтогоСуммаНДС=0;
	
	ДолгКредитора=ДанныеДокумента.ДолгКредитора.Выгрузить();
	Для Каждого СтрокаПродажи ИЗ ДолгКредитора Цикл
		ОбластьМакета=Макет.ПолучитьОбласть("СтрокаТЧ");
		ОбластьМакета.Параметры.стрДокумент=?(ЗначениеЗаполнено(СтрокаПродажи.ДокументРасчетовСКонтрагентом),Строка(СтрокаПродажи.ДокументРасчетовСКонтрагентом)+" по договору "+Строка(СтрокаПродажи.ДоговорКонтрагента),СтрокаПродажи.ДоговорКонтрагента);
		СуммаДокумента=?(ЗначениеЗаполнено(СтрокаПродажи.ДокументРасчетовСКонтрагентом),СтрокаПродажи.ДокументРасчетовСКонтрагентом.СуммаДокумента,СтрокаПродажи.Сумма);
		ОбластьМакета.Параметры.СуммаДокумента=СуммаДокумента;
		ОбластьМакета.Параметры.СуммаЗачета=СтрокаПродажи.СуммаРегл;
		ОбластьМакета.Параметры.СуммаНДС=СтрокаПродажи.СуммаНДС;
		ИтогоСуммаДокумента=ИтогоСуммаДокумента+СуммаДокумента;
		ИтогоСуммаЗачета=ИтогоСуммаЗачета+СтрокаПродажи.СуммаРегл;
		ИтогоСуммаНДС=ИтогоСуммаНДС+СтрокаПродажи.СуммаНДС;
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;
	ОбластьМакета=Макет.ПолучитьОбласть("ПодвалТЧ");
	ОбластьМакета.Параметры.ИтогоСуммаДокумента=ИтогоСуммаДокумента;
	ОбластьМакета.Параметры.ИтогоСуммаЗачетаПрописью=ОбщегоНазначения.СформироватьСуммуПрописью(ИтогоСуммаЗачета, МодульВалютногоУчета.ПолучитьВалюту("Бух"));
	ОбластьМакета.Параметры.ИтогоСуммаЗачета=ИтогоСуммаЗачета;
	ОбластьМакета.Параметры.ИтогоСуммаНДС=ИтогоСуммаНДС;
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
	СведенияОбОрганизации = КонтактнаяИнформацияСервер.СведенияОЮрФизЛице(ДанныеДокумента.Организация, ДанныеДокумента.Дата);
	СведенияОКонтрагенте  = КонтактнаяИнформацияСервер.СведенияОЮрФизЛице(ДанныеДокумента.КонтрагентКредитор, ДанныеДокумента.Дата);
	
	ОбластьМакета.Параметры.НомерСтороны=НомерСтороны;
	ОбластьМакета.Параметры.Организация=СокрЛП(ДанныеДокумента.ОрганизацияНаименованиеПолное);
	ОбластьМакета.Параметры.ОрганизацияИНН=Строка(СведенияОбОрганизации.ИНН);
	ОбластьМакета.Параметры.ФактицескийАдресОрганизация=Строка(СведенияОбОрганизации.ФактическийАдрес);
	ОбластьМакета.Параметры.ТелефонОрганизация=Строка(СведенияОбОрганизации.Телефоны);
	
	ОбластьМакета.Параметры.Контрагент=СокрЛП(ДанныеДокумента.КонтрагентКредиторНаименованиеПолное);
	ОбластьМакета.Параметры.КонтрагентИНН=Строка(СведенияОКонтрагенте.ИНН);
	ОбластьМакета.Параметры.ФактическийАдресКонтрагент=Строка(СведенияОКонтрагенте.ФактическийАдрес);
	ОбластьМакета.Параметры.ТелефонКонтрагент=Строка(СведенияОКонтрагенте.Телефоны);
	
	ОбластьМакета.Параметры.Руководитель=Руководители.Руководитель;
	ОбластьМакета.Параметры.ГлавныйБухгалтер=Руководители.ГлавныйБухгалтер;
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	Если АктТрехсторонний Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалСторона3");
		СведенияОКонтрагенте  = КонтактнаяИнформацияСервер.СведенияОЮрФизЛице(ДанныеДокумента.КонтрагентДебитор, ДанныеДокумента.Дата);
		
		ОбластьМакета.Параметры.Контрагент=СокрЛП(ДанныеДокумента.КонтрагентДебиторНаименованиеПолное);
		ОбластьМакета.Параметры.КонтрагентИНН=Строка(СведенияОКонтрагенте.ИНН);
		ОбластьМакета.Параметры.ФактическийАдресКонтрагент=Строка(СведенияОКонтрагенте.ФактическийАдрес);
		ОбластьМакета.Параметры.ТелефонКонтрагент=Строка(СведенияОКонтрагенте.Телефоны);
		
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЕсли;
	
	Возврат ТабДокумент;
КонецФункции

Функция Печать_УведомлениеОЗачете_ПараметрыПечати(СтруктураПараметров)
	СсылкаНаОбъект=СтруктураПараметров.СсылкаНаОбъект;
	тзДанные=ПолучитьДанныеДокумента(СсылкаНаОбъект);
	ПараметрыПечати = Новый Структура;
	Для каждого СтрокаКоллекции Из тзДанные.Колонки Цикл
		ПараметрыПечати.Вставить(СтрокаКоллекции.Имя, тзДанные[0][СтрокаКоллекции.Имя]);
	КонецЦикла;
	СведенияОбОрганизации = КонтактнаяИнформацияСервер.СведенияОЮрФизЛице(ПараметрыПечати.Организация, ПараметрыПечати.Дата);
	СведенияОКонтрагенте  = КонтактнаяИнформацияСервер.СведенияОЮрФизЛице(ПараметрыПечати.КонтрагентКредитор, ПараметрыПечати.Дата);
	
	ПараметрыПечати.Организация=СокрЛП(ПараметрыПечати.ОрганизацияНаименованиеПолное);
	ПараметрыПечати.Вставить("ОрганизацияИНН",Строка(СведенияОбОрганизации.ИНН));
	ПараметрыПечати.Вставить("ФактицескийАдресОрганизация",Строка(СведенияОбОрганизации.ФактическийАдрес));
	ПараметрыПечати.Вставить("ТелефонОрганизация",Строка(СведенияОбОрганизации.Телефоны));
	ПараметрыПечати.Вставить("Контрагент",СокрЛП(ПараметрыПечати.КонтрагентКредиторНаименованиеПолное));
	ПараметрыПечати.Вставить("КонтрагентИНН",Строка(СведенияОКонтрагенте.ИНН));
	ПараметрыПечати.Вставить("ФактическийАдресКонтрагент",Строка(СведенияОКонтрагенте.ФактическийАдрес));
	ПараметрыПечати.Вставить("ТелефонКонтрагент",Строка(СведенияОКонтрагенте.Телефоны));
	ПараметрыПечати.Вставить("СуммаПогашения",ПараметрыПечати.СуммаДокумента);
	ПараметрыПечати.Вставить("СуммаПогашенияПрописью",ОбщегоНазначения.СформироватьСуммуПрописью(ПараметрыПечати.СуммаДокумента, МодульВалютногоУчета.ПолучитьВалюту("Бух")));
	ИтогоСуммаДокументаПокупки=0; ИтогоСуммаЗачетаПокупки=0; ИтогоСуммаНДСПокупки=0;
	ИтогоСуммаДокументаПродажи=0; ИтогоСуммаЗачетаПродажи=0; ИтогоСуммаНДСПродажи=0;

	ПараметрыПечати.ДолгДебитора.Колонки.Добавить("СуммаДокументаПродажи");
	ПараметрыПечати.ДолгДебитора.Колонки.Добавить("СуммаЗачетаПродажи");
	ПараметрыПечати.ДолгДебитора.Колонки.Добавить("СуммаНДСПродажи");
	ПараметрыПечати.ДолгДебитора.Колонки.Добавить("стрДокументПродажи");
	Для Каждого СтрокаКоллекции ИЗ ПараметрыПечати.ДолгДебитора Цикл
		стрДокументПродажи=?(ЗначениеЗаполнено(СтрокаКоллекции.ДокументРасчетовСКонтрагентом),Строка(СтрокаКоллекции.ДокументРасчетовСКонтрагентом)+" по договору "+Строка(СтрокаКоллекции.ДоговорКонтрагента),СтрокаКоллекции.ДоговорКонтрагента);
		СуммаДокумента=?(ЗначениеЗаполнено(СтрокаКоллекции.ДокументРасчетовСКонтрагентом),СтрокаКоллекции.ДокументРасчетовСКонтрагентом.СуммаДокумента,СтрокаКоллекции.СуммаРегл);
		СуммаЗачета=СтрокаКоллекции.СуммаРегл;
		СтрокаКоллекции.СуммаДокументаПродажи=СуммаДокумента;
		СтрокаКоллекции.СуммаЗачетаПродажи=СуммаЗачета;
		СтрокаКоллекции.СуммаНДСПродажи=СтрокаКоллекции.СуммаНДС;
		СтрокаКоллекции.стрДокументПродажи=стрДокументПродажи;
		ИтогоСуммаДокументаПродажи=ИтогоСуммаДокументаПродажи+СуммаДокумента;
		ИтогоСуммаЗачетаПродажи=ИтогоСуммаЗачетаПродажи+СуммаЗачета;
		ИтогоСуммаНДСПродажи=ИтогоСуммаНДСПродажи+СтрокаКоллекции.СуммаНДС;
	КонецЦикла;	
	ПараметрыПечати.Вставить("ИтогоСуммаДокументаПродажи",ИтогоСуммаДокументаПродажи);
	ПараметрыПечати.Вставить("ИтогоСуммаЗачетаПродажи",ИтогоСуммаЗачетаПродажи);
	ПараметрыПечати.Вставить("ИтогоСуммаНДСПродажи",ИтогоСуммаНДСПродажи);
	
	ПараметрыПечати.ДолгКредитора.Колонки.Добавить("СуммаДокументаПокупки");
	ПараметрыПечати.ДолгКредитора.Колонки.Добавить("СуммаЗачетаПокупки");
	ПараметрыПечати.ДолгКредитора.Колонки.Добавить("СуммаНДСПокупки");
	ПараметрыПечати.ДолгКредитора.Колонки.Добавить("стрДокументПокупки");
	Для Каждого СтрокаКоллекции ИЗ ПараметрыПечати.ДолгКредитора Цикл
		стрДокументПокупки=?(ЗначениеЗаполнено(СтрокаКоллекции.ДокументРасчетовСКонтрагентом),Строка(СтрокаКоллекции.ДокументРасчетовСКонтрагентом)+" по договору "+Строка(СтрокаКоллекции.ДоговорКонтрагента),СтрокаКоллекции.ДоговорКонтрагента);
		СуммаДокумента=?(ЗначениеЗаполнено(СтрокаКоллекции.ДокументРасчетовСКонтрагентом),СтрокаКоллекции.ДокументРасчетовСКонтрагентом.СуммаДокумента,СтрокаКоллекции.СуммаРегл);
		СуммаЗачета=СтрокаКоллекции.СуммаРегл;
		СтрокаКоллекции.СуммаДокументаПокупки=СуммаДокумента;
		СтрокаКоллекции.СуммаЗачетаПокупки=СуммаЗачета;
		СтрокаКоллекции.СуммаНДСПокупки=СтрокаКоллекции.СуммаНДС;
		СтрокаКоллекции.стрДокументПокупки=стрДокументПокупки;
		ИтогоСуммаДокументаПокупки=ИтогоСуммаДокументаПокупки+СуммаДокумента;
		ИтогоСуммаЗачетаПокупки=ИтогоСуммаЗачетаПокупки+СуммаЗачета;
		ИтогоСуммаНДСПокупки=ИтогоСуммаНДСПокупки+СтрокаКоллекции.СуммаНДС;
	КонецЦикла;

	ПараметрыПечати.Вставить("ИтогоСуммаДокументаПокупки",ИтогоСуммаДокументаПокупки);
	ПараметрыПечати.Вставить("ИтогоСуммаЗачетаПокупки",ИтогоСуммаЗачетаПокупки);
	ПараметрыПечати.Вставить("ИтогоСуммаНДСПокупки",ИтогоСуммаНДСПокупки);
	
	Руководители = ПечатныеФормыСервер.ОтветственныеЛицаОрганизации(ПараметрыПечати.Организация, ПараметрыПечати.Дата, СсылкаНаОбъект);
	ПараметрыПечати.Вставить("Руководитель",Руководители.Руководитель);
	ПараметрыПечати.Вставить("ГлавныйБухгалтер",Руководители.ГлавныйБухгалтер);

	Если СтруктураПараметров.Свойство("МодульПечати") Тогда
		стрТекстМодуля=СтруктураПараметров.МодульПечати.ПараметрыПечатнойФормы.ТекстМодуля;
		Если Не ПустаяСтрока(стрТекстМодуля) Тогда Выполнить(стрТекстМодуля); КонецЕсли;
	КонецЕсли;	
	
	Возврат ПараметрыПечати;
КонецФункции

Функция Печать_УведомлениеОЗачете(СтруктураПараметров)
	ПараметрыПечати=Печать_УведомлениеОЗачете_ПараметрыПечати(СтруктураПараметров);
	Если ПараметрыПечати.Свойство("Отказ") И ПараметрыПечати.Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;

	ТабДокумент=Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_АктВзаимозачета_УведомлениеОЗачете";
	
	Макет=ИнициализацияМакета(СтруктураПараметров, "УведомлениеОЗачете");
	
	ОбластьМакета=Макет.ПолучитьОбласть("Шапка");
	ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);
	
	КоличествоСтрок=?(ПараметрыПечати.ДолгДебитора.Количество()>ПараметрыПечати.ДолгКредитора.Количество(),ПараметрыПечати.ДолгДебитора.Количество(),ПараметрыПечати.ДолгКредитора.Количество());
	Для ъ=1 По КоличествоСтрок Цикл
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		Если ъ <= ПараметрыПечати.ДолгДебитора.Количество() Тогда
			СтрокаТЗ=ПараметрыПечати.ДолгДебитора[ъ-1];
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтрокаТЗ);
		КонецЕсли;
		
		Если ъ <= ПараметрыПечати.ДолгКредитора.Количество() Тогда			
			СтрокаТЗ=ПараметрыПечати.ДолгКредитора[ъ-1];
			ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, СтрокаТЗ);
		КонецЕсли;
		ТабДокумент.Вывести(ОбластьМакета);
	КонецЦикла;	
	
	ОбластьМакета=Макет.ПолучитьОбласть("ПодвалТЧ");
	ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);

	ОбластьМакета=Макет.ПолучитьОбласть("Подвал");
	ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ПараметрыПечати);
	ТабДокумент.Вывести(ОбластьМакета);
	
	Возврат ТабДокумент;
КонецФункции	

Функция Печать(СтруктураПараметров, КоличествоЭкземпляров=1, НаПринтер=Ложь, ТабДокумент=Неопределено) Экспорт
	Если СтруктураПараметров.ИмяМакета="АктВзаимозачета" Тогда		
		ТабДокумент=Печать_АктВзаимозачета(СтруктураПараметров);

	ИначеЕсли СтруктураПараметров.ИмяМакета="УведомлениеОЗачете" Тогда		
		ТабДокумент=Печать_УведомлениеОЗачете(СтруктураПараметров);

	ИначеЕсли СтруктураПараметров.ИмяМакета="БухгалтерскаяСправка" Тогда
		ТабДокумент=ПечатныеФормыСервер.БухгалтерскаяСправка(СтруктураПараметров, "Хозрасчетный");		
	КонецЕсли;

	Возврат ТабДокумент;
КонецФункции
