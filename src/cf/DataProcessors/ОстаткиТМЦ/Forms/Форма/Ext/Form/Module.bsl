﻿&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	стрИмя=?(ТипЗнч(Команда)=Тип("Строка"), Команда, Команда.Имя);

	Если стрИмя="ОстаткиОбновить" Тогда
		дзОстатки_Сформировать();

		ЭлементыКоллекции=дзОстатки.ПолучитьЭлементы();
		Для каждого СтрокаКоллекции Из ЭлементыКоллекции Цикл
			Элементы.дзОстатки.Развернуть(СтрокаКоллекции.ПолучитьИдентификатор(), Истина);
		КонецЦикла;
		
	ИначеЕсли стрИмя="ОстаткиНастройка" Тогда
		Элементы.ГруппаНастройки.Видимость=НЕ Элементы.ГруппаНастройки.Видимость;

	ИначеЕсли стрИмя="ВводДаты" Тогда	
		ОписаниеОповещения=Новый ОписаниеОповещения("ОбработкаОповещения_ВводДаты", ЭтотОбъект);
		ПоказатьВводДаты(ОписаниеОповещения, НаДату, "Введите дату остатков");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения_ВводДаты(Параметр1, Параметр2) Экспорт
	Если Параметр1=Неопределено Тогда Возврат; КонецЕсли;
	НаДату=Параметр1;
	Элементы.дзОстаткиВводДаты.Заголовок="Остатки на: "+СокрЛП(НаДату);
	ВыполнитьДействие(Команды.ОстаткиОбновить);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий табличного поля "Остатки"

&НаСервере
Процедура дзОстатки_Сформировать()
	дзДанные=Новый ДеревоЗначений;
	дзОстатки.ПолучитьЭлементы().Очистить();

	СхемаКомпоновкиДанных=Обработки.ОстаткиТМЦ.ПолучитьМакет("Остатки");

	МассивГруппировок=Новый Массив;
	Для каждого СтрокаКоллекции Из спОстаткиГруппировки Цикл
		Если НЕ СтрокаКоллекции.Пометка Тогда Продолжить; КонецЕсли; 
		МассивГруппировок.Добавить(СтрокаКоллекции.Значение);
	КонецЦикла;

	Если НЕ МассивГруппировок.Количество()=0 Тогда
		КомпоновщикНастроек.Настройки.Структура.Очистить();
		
		ЭлементСтруктуры=КомпоновщикНастроек.Настройки;
		Для каждого СтрокаКоллекции Из МассивГруппировок Цикл
			ЭлементСтруктуры=ЭлементСтруктуры.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ЭлементСтруктуры.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			ЭлементСтруктуры.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));

			ПолеГруппировки=ЭлементСтруктуры.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование=Истина;
			ПолеГруппировки.Поле=Новый ПолеКомпоновкиДанных(СтрокаКоллекции);			
		КонецЦикла; 
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("Период", НаДату);
	
	КомпоновщикМакета=Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки=КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
	ПроцессорКомпоновкиДанных=Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки);
	
	ПроцессорВывода=Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(дзДанные);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

	Если дзДанные.Строки.Количество()=0 Тогда Возврат; КонецЕсли;
	
	дзОстатки_Заполнить(дзДанные.Строки, дзОстатки.ПолучитьЭлементы(), МассивГруппировок, 0);
	
	МассивСтрок=дзОстатки.ПолучитьЭлементы();
	МассивСтрок[МассивСтрок.Количество()-1].Представление="Итого:";
КонецПроцедуры

&НаСервере
Процедура дзОстатки_Заполнить(Источник, Приемник, МассивГруппировок, ИндексМассиваИзмерений)
	Для каждого СтрокаКоллекции Из Источник Цикл
		НоваяСтрока=Приемник.Добавить();
		НоваяСтрока.Представление=СтрокаКоллекции[МассивГруппировок[ИндексМассиваИзмерений]];
		НоваяСтрока.Количество=СтрокаКоллекции.Количество;

		дзОстатки_Заполнить(СтрокаКоллекции.Строки, Приемник[Источник.Индекс(СтрокаКоллекции)].ПолучитьЭлементы(), МассивГруппировок, ИндексМассиваИзмерений+1);		
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура дзОстатки_Инициализация()
	СхемаКомпоновкиДанных=Обработки.ОстаткиТМЦ.ПолучитьМакет("Остатки");
	
	стрЗапрос=СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос;
	
	Если Константы.УчетПотребностей.Получить() Тогда
		стрЗапрос=стрЗапрос+"
		|Объединить ВСЕ
		|	ВЫБРАТЬ
		|	ИсточникДанных.Номенклатура КАК Номенклатура,
		|	ИсточникДанных.Склад КАК Склад,
		|	ИсточникДанных.Организация КАК Организация,
		|	ИсточникДанных.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	Неопределено КАК СерияНоменклатуры,
		|	Неопределено КАК Качество,
		|	0 КАК Резерв,
		|	ИсточникДанных.КоличествоОстаток КАК Потребность,
		|	0 КАК Количество
		|ИЗ
		|	РегистрНакопления.УчетПотребностей.Остатки(&НаДату) КАК ИсточникДанных
		|";
		Элементы.дзОстаткиПотребность.Видимость=Истина;
	КонецЕсли; 
	
	Если Константы.УчетРезервов.Получить() Тогда
		стрЗапрос=стрЗапрос+"
		|Объединить ВСЕ
		|	ВЫБРАТЬ
		|	ИсточникДанных.Номенклатура КАК Номенклатура,
		|	ИсточникДанных.Склад КАК Склад,
		|	ИсточникДанных.Организация КАК Организация,
		|	ИсточникДанных.ХарактеристикаНоменклатуры КАК ХарактеристикаНоменклатуры,
		|	ИсточникДанных.СерияНоменклатуры КАК СерияНоменклатуры,
		|	Неопределено КАК Качество,
		|	ИсточникДанных.КоличествоОстаток КАК Резерв,
		|	0 КАК Потребность,
		|	0 КАК Количество
		|ИЗ
		|	РегистрНакопления.УчетРезервовТМЦ.Остатки(&НаДату) КАК ИсточникДанных
		|";
		Элементы.дзОстаткиРезерв.Видимость=Истина;
	КонецЕсли;

	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос=стрЗапрос;
	
	URLСхемы=ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());

	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(URLСхемы));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);

	Если ТипЗнч(Отбор)=Тип("Структура") Тогда
		Для каждого СтрокаКоллекции Из Отбор Цикл
			ЭлементОтбора=КомпоновщикНастроек.Настройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
			ЭлементОтбора.Использование=Истина;
			ЭлементОтбора.ВидСравнения=?(ТипЗнч(СтрокаКоллекции.Значение)=Тип("СписокЗначений"), ВидСравненияКомпоновкиДанных.ВСписке, ВидСравненияКомпоновкиДанных.Равно);
			ЭлементОтбора.ЛевоеЗначение=Новый ПолеКомпоновкиДанных(СтрокаКоллекции.Ключ);
			ЭлементОтбора.ПравоеЗначение=СтрокаКоллекции.Значение;
		КонецЦикла;
	КонецЕсли;

	спОстаткиГруппировки.Добавить("Номенклатура", "Номенклатура", Истина);
	спОстаткиГруппировки.Добавить("Организация", "Организация", Истина);
	спОстаткиГруппировки.Добавить("Склад", "Склад", Истина);
	Если Константы.ИспользоватьХарактеристикиНоменклатуры.Получить() Тогда
		спОстаткиГруппировки.Добавить("ХарактеристикаНоменклатуры", "Характеристика номенклатуры", Ложь);
	КонецЕсли;
	Если Константы.ИспользоватьСерииНоменклатуры.Получить() Тогда
		спОстаткиГруппировки.Добавить("СерияНоменклатуры", "Серия номенклатуры", Ложь);
	КонецЕсли;
	спОстаткиГруппировки.Добавить("Качество", "Качество");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("Дата", НаДату);	
	Параметры.Свойство("Отбор", Отбор);
	Если Не ЗначениеЗаполнено(НаДату) Тогда
		НаДату=ТекущаяДата();
	КонецЕсли;	
	дзОстатки_Инициализация();	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Элементы.дзОстаткиВводДаты.Заголовок="Остатки на: "+СокрЛП(НаДату);
	ВыполнитьДействие(Команды.ОстаткиОбновить);
    ЗакрыватьПриЗакрытииВладельца=Истина;
КонецПроцедуры