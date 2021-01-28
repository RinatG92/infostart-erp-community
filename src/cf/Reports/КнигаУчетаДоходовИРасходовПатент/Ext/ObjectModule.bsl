﻿#Если Клиент Тогда
	
Перем НП Экспорт;

Процедура ПечатьТитульногоЛиста(ДокументРезультат)

	ДокументРезультат.Очистить();
	ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КнигаУчетаДоходовИРасходов_ТитульныйЛист";
	
    Секция = ПолучитьМакет("ТитульныйЛист_154н");
	
	Сведения = КонтактнаяИнформацияСервер.СведенияОЮрФизЛице(Организация,,);
	
	Секция.Параметры.НаПериод         = "на " + Формат(Год(ДатаКон), "ЧГ=") + " год";
	Секция.Параметры.ПолноеНаименованиеОрганизации = ПечатныеФормыСервер.ОписаниеОрганизации(Сведения, "НаименованиеДляПечатныхФорм");;
	Секция.Параметры.КодОКПО          = Сведения.КодПоОКПО;
			
	//Соберем банковские счета
	Счета = "";
	
	ЗапросБС = Новый Запрос;
	ЗапросБС.УстановитьПараметр("Владелец", Организация);
	ЗапросБС.УстановитьПараметр("НачДата", НачалоМесяца(ДатаНач));
	ЗапросБС.УстановитьПараметр("КонДата", КонецМесяца(ДатаКон));
	ЗапросБС.УстановитьПараметр("ПустаяДата", Дата("00010101"));
	ЗапросБС.Текст =
	"ВЫБРАТЬ
	|	БанковскиеСчета.НомерСчета КАК Номер,
	|	БанковскиеСчета.Банк.Наименование КАК Банк
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Владелец = &Владелец
	|	И (БанковскиеСчета.ДатаОткрытия = &ПустаяДата ИЛИ БанковскиеСчета.ДатаОткрытия <= &КонДата)
	|	И (БанковскиеСчета.ДатаЗакрытия = &ПустаяДата ИЛИ БанковскиеСчета.ДатаОткрытия >= &НачДата)";
	
	
	БанковскиеСчета = ЗапросБС.Выполнить().Выгрузить();
	Для Каждого Строка Из БанковскиеСчета Цикл
		НомСч = СокрЛП(Строка.Номер);
		Банк  = СокрЛП(Строка.Банк);
		Счета = Счета+"№ "+НомСч+" в "+Банк+", ";
	КонецЦикла;	                         
	Счета = Лев(Счета,СтрДлина(Счета)-2);
	Секция.Параметры.Счета            = Счета;
		
	
	СтрокаАдреса = СокрЛП(Сведения.ФактическийАдрес);
	Секция.Параметры.АдресОрганизации = Сведения.ФактическийАдрес;
	Секция.Параметры.СрокПатента = "с " + Формат(НачалоМесяца(ДатаНач), "ДФ=""дд ММММ гггг 'г.'""") + " по " + Формат(КонецМесяца(ДатаКон), "ДФ=""дд ММММ гггг 'г.'""");	
	ДокументРезультат.Вывести(Секция);
	
			
		ИНН = Сведения.ИНН;
		
		Если СтрДлина(ИНН) <> 12 Тогда
			// Налогоплательщик - юр. лицо		
			ИНН = "00" + ИНН;		
		КонецЕсли;
		
		Ном = 1;
		Пока Ном > 0 Цикл
			ИмяОбластиИНН = "ПрИНН";
			Если НЕ(Ном > 12) Тогда
				ДокументРезультат.Область(ИмяОбластиИНН + Ном).Текст = ?(Число(ИНН) > 0, Сред(ИНН, Ном, 1), ""); 
				
				Ном = Ном + 1;
				Продолжить;
			КонецЕсли;
			Ном = 0;
		КонецЦикла;
	
	ДокументРезультат.ТолькоПросмотр = Истина;

КонецПроцедуры

Процедура ПечатьРаздела1(ДокументРезультат)
	
	ДокументРезультат.Очистить();
	ДокументРезультат.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КнигаУчетаДоходовИРасходовПатент_Раздел1";
	Макет = ПолучитьМакет("Раздел1_154н");
	
	Секция = Макет.ПолучитьОбласть("Шапка");
	ДокументРезультат.Вывести(Секция);
	
	ВсегоДоходов = 0;
	НПП = 1;
	ЗапросДР = Новый Запрос;
	ЗапросДР.УстановитьПараметр("НачДата", НачалоМесяца(ДатаНач));
	ЗапросДР.УстановитьПараметр("КонДата", КонецМесяца(ДатаКон));
	ЗапросДР.УстановитьПараметр("Организация", Организация);
	ЗапросДР.Текст = 
	"ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрНакопления.КнигаУчетаДоходовИРасходов КАК КнигаУчетаДоходовИРасходов
	|ГДЕ
	|	КнигаУчетаДоходовИРасходов.Организация = &Организация
	|	И КнигаУчетаДоходовИРасходов.Активность
	|	И КнигаУчетаДоходовИРасходов.Период МЕЖДУ &НачДата И &КонДата";
	
	ВыборкаЗаписей = ЗапросДР.Выполнить().Выбрать();
	Пока ВыборкаЗаписей.Следующий() Цикл
		Если ВыборкаЗаписей.Патент = 0 Тогда Продолжить; КонецЕсли;

		Секция=Макет.ПолучитьОбласть("Строка");
		Секция.Параметры.НомерПП = НПП;
		Секция.Параметры.ТекРасшифровка= ВыборкаЗаписей.Регистратор;
		Секция.Параметры.ПечДатаНомерДок = ВыборкаЗаписей.Графа2;
		Секция.Параметры.ПечСодержОпер = ВыборкаЗаписей.Содержание;
		Секция.Параметры.ПечДоходыБУ = ВыборкаЗаписей.Патент;
		
		ВсегоДоходов = ВсегоДоходов + ВыборкаЗаписей.Патент;
						
		ДокументРезультат.Вывести(Секция);
									
		НПП = НПП + 1;		
	КонецЦикла;
		
	// Выведем подвал
	Секция = Макет.ПолучитьОбласть("Итого");
	Секция.Параметры.ПечДоходыБУ = ВсегоДоходов;
		
	ДокументРезультат.Вывести(Секция);
		
	ДокументРезультат.ТолькоПросмотр = Истина;
	ДокументРезультат.ПовторятьПриПечатиСтроки = ДокументРезультат.Область(6,,6,);
	
КонецПроцедуры

Процедура СформироватьОтчет(ТитульныйЛист, Раздел1) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Сообщить("Не указана организация!");
		Возврат;
	КонецЕсли;
		
	ПечатьТитульногоЛиста(ТитульныйЛист);
	ПечатьРаздела1(Раздел1);
	
КонецПроцедуры

НП = Новый НастройкаПериода;

#КонецЕсли