﻿Процедура ПередЗаписью(Отказ)
	Если НЕ ЭтоГруппа И НЕ ОбменДанными.Загрузка Тогда
		СтрокаОшибки="Элемент справочника ""Банки"" "+Наименование+" не записан!";
		Если ОбщегоНазначения.ЕстьНеЦифры(КоррСчет) Тогда
			ОбщегоНазначения.СообщитьОбОшибке("В составе Корр.счета банка должны быть только цифры.",, СтрокаОшибки);
			Отказ=Истина;
		КонецЕсли;	
	КонецЕсли; 
	
КонецПроцедуры

