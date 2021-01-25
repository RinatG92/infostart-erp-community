﻿&НаКлиенте
Процедура ВыполнитьДействие(Команда)
	стрИмя=Команда.Имя;
	Если стрИмя="ОтправитьПоПочте" Тогда
		//УправлениеОтчетами.ОтправитьДокументПоЭлектроннойПочте(Таб, Заголовок, Объект.ОбъектПечати);

	ИначеЕсли стрИмя="Печать" Тогда
		Таб.КоличествоЭкземпляров=КоличествоЭкземпляров;
		Если ЗначениеЗаполнено(стрТипДвустороннейПечати) Тогда
			Таб.ДвусторонняяПечать=ТипДвустороннейПечати[стрТипДвустороннейПечати];
		КонецЕсли;		
		Таб.Напечатать(Истина);
		//ЭтаФорма.Закрыть();

	ИначеЕсли стрИмя="Поделиться" Тогда
		ОткрытьФорму("РегистрСведений.Share.Форма.ФормаЗаписи",Новый Структура("ТабличныйДокумент", Таб),,УникальныйИдентификатор,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

	ИначеЕсли стрИмя="Сохранить" Тогда
	//	Диалог=Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	//	Диалог.Заголовок="Сохранить как";
	//	Диалог.ПолноеИмяФайла=СтрЗаменить(ЭтаФорма.Заголовок, ".", "_");
	//	Диалог.ПредварительныйПросмотр=Ложь;
	//	Диалог.Фильтр="Табличный документ (*.mxl)|*.mxl|"+"Документ Microsoft Excel (*.xls)|*.xls|";
	//	//Диалог.Показать(О
	//	Если Не Диалог.Выбрать() Тогда Возврат; КонецЕсли; 

	//	ИмяФайла=Диалог.ПолноеИмяФайла;
	//	Попытка Таб.Записать(ИмяФайла, ?(Прав(ИмяФайла,3) = "xls", ТипФайлаТабличногоДокумента.XLS, ТипФайлаТабличногоДокумента.MXL));
	//	Исключение ПоказатьПредупреждение(, "Ошибка при записи. Файл не записан.");
	//	КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Атрибут_ПриИзменении(Элемент)
	Если Элемент.Имя="КоличествоЭкземпляров" Тогда
		Таб.КоличествоЭкземпляров=КоличествоЭкземпляров;
	КонецЕсли;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий формы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПечатныйДокумент=Неопределено; Параметры.Свойство("ПечатныйДокумент", ПечатныйДокумент);
	ОбъектПечати=Неопределено; Параметры.Свойство("ОбъектПечати", ОбъектПечати);
	Параметры.Свойство("КоличествоЭкземпляров", КоличествоЭкземпляров);
	Параметры.Свойство("НаПринтер", НаПринтер);
	Параметры.Свойство("ПараметрыПечатнойФормы", ПараметрыПечатнойФормы);

	Если КоличествоЭкземпляров=0 Тогда
		КоличествоЭкземпляров=1;
	КонецЕсли;

	Заголовок=СокрЛП(ОбъектПечати);	
	ЗаполнитьЗначенияСвойств(Таб, ПечатныйДокумент,,"Области");

	Таб.ВставитьОбласть(ПечатныйДокумент.Область());
	Таб.Защита=УправлениеПользователямиСервер.ЗащитаТаблиц();
	Таб.КоличествоЭкземпляров=КоличествоЭкземпляров;

	Для каждого СтрокаКоллекции Из ПараметрыПечатнойФормы Цикл
		Если СтрокаКоллекции.Ключ="ДвусторонняяПечать" Тогда
			Если ЗначениеЗаполнено(СтрокаКоллекции.Значение) Тогда
				стрТипДвустороннейПечати=СтрокаКоллекции.Значение; //***
				Таб[СтрокаКоллекции.Ключ]=ТипДвустороннейПечати[СтрокаКоллекции.Значение];
			КонецЕсли;

		ИначеЕсли СтрокаКоллекции.Ключ="АвтоМасштаб" Или СтрокаКоллекции.Ключ="МасштабПечати" Или СтрокаКоллекции.Ключ="ИспользуемоеИмяФайла" Или СтрокаКоллекции.Ключ="ИмяПринтера" Тогда
			Если ЗначениеЗаполнено(СтрокаКоллекции.Значение) Тогда
				Таб[СтрокаКоллекции.Ключ]=СтрокаКоллекции.Значение;
			КонецЕсли;

		ИначеЕсли СтрокаКоллекции.Ключ="ОриентацияСтраницы" Тогда
			Если ЗначениеЗаполнено(СтрокаКоллекции.Значение) Тогда
				Таб[СтрокаКоллекции.Ключ]=ОриентацияСтраницы[СтрокаКоллекции.Значение];
			КонецЕсли;
		Иначе
			Таб[СтрокаКоллекции.Ключ]=СтрокаКоллекции.Значение;			
		КонецЕсли;
	КонецЦикла;

	Если НаПринтер Тогда
		Таб.Вывод=ИспользованиеВывода.Разрешить;
		Таб.Напечатать(); Отказ=Истина; Возврат;
	КонецЕсли;

	Если НЕ ПараметрыПечатнойФормы.Количество()=0 Тогда
		ЗаполнитьЗначенияСвойств(Элементы.ПолеТабличногоДокумента, Таб);
	КонецЕсли;	
КонецПроцедуры