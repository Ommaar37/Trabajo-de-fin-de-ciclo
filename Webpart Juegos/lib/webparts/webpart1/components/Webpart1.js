var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
import * as React from 'react';
import { Button, Modal, Table } from 'antd';
import { useState } from 'react';
import styles from "./Webpart1.module.scss";
import { TextField } from '@fluentui/react/lib/TextField';
import { Stack } from '@fluentui/react/lib/Stack';
import { Dropdown, DropdownMenuItemType } from '@fluentui/react/lib/Dropdown';
import { DatePicker, DayOfWeek, defaultDatePickerStrings, } from '@fluentui/react';
import * as moment from "moment";
//Definición de las columnas y petición para extraer los datos de la misma.
var columns = [
    {
        title: 'Nombre',
        dataIndex: 'Title',
        key: 'Title',
    },
    {
        title: 'Descripción',
        dataIndex: 'J_Desc',
        key: 'J_Desc',
    },
    {
        title: 'Fecha lanzamiento',
        dataIndex: 'J_Lanz',
        key: 'J_Lanz',
        render: function (dateString) { return moment(dateString).format('DD/MM/YYYY'); },
    },
    {
        title: 'Género',
        dataIndex: 'J_Gen',
        key: 'J_Gen',
    },
    {
        title: 'Duración',
        dataIndex: 'J_Dur',
        key: 'J_Dur',
    },
];
//Función para coger los datos de la lista ya creada de Sharepoint.
export default function HelloWorld(props) {
    var _a = React.useState(null), datos = _a[0], setDatos = _a[1];
    React.useEffect(function () {
        cargarDatos();
    }, []);
    var cargarDatos = function () {
        return __awaiter(this, void 0, void 0, function () {
            var lista, juegos, filas;
            return __generator(this, function (_a) {
                switch (_a.label) {
                    case 0: return [4 /*yield*/, props.SP.web.lists.getByTitle("Juegos")];
                    case 1:
                        lista = _a.sent();
                        return [4 /*yield*/, lista.items.top(5000).select("*")()];
                    case 2:
                        juegos = _a.sent();
                        filas = [];
                        juegos.map(function (j) {
                            filas.push({
                                'Title': j.Title,
                                'J_Dur': j.J_Dur,
                                'J_Lanz ': j.J_Lanz,
                                'J_Desc': j.J_Desc,
                                'J_Gen': j.J_Gen
                            });
                            console.log(j.Title);
                        });
                        setDatos(juegos);
                        return [2 /*return*/];
                }
            });
        });
    };
    //Creación del pop-up del botón para añadir nuevos juegos a la lista
    var _b = useState(false), isModalOpen = _b[0], setIsModalOpen = _b[1];
    var showModal = function () {
        setIsModalOpen(true);
    };
    var handleOk = function () {
        setIsModalOpen(false);
    };
    var handleCancel = function () {
        setIsModalOpen(false);
    };
    //Creación de los campos de texto de nuestro pop-up
    var stackStyles = { root: { width: 650 } };
    var columnProps = {
        tokens: { childrenGap: 15 },
        styles: { root: { width: 300 } },
    };
    //Creación de los 2 selectores de nuestro pop-up
    var dropdownStyles = {
        dropdown: { width: 300 },
    };
    var optionsgenero = [
        { key: 'genero', text: 'Género', itemType: DropdownMenuItemType.Header },
        { key: 'accion', text: 'Acción' },
        { key: 'plataformas', text: 'Plataformas' },
        { key: 'lucha', text: 'Lucha' },
        { key: 'shooter', text: 'Shooter' },
        { key: 'arcade', text: 'Arcade' },
        { key: 'aventura', text: 'Aventura' },
        { key: 'estrategia', text: 'Estrategia' },
        { key: 'deportes', text: 'Deportes' },
        { key: 'simulacion', text: 'Simulación' },
    ];
    var optionsduracion = [
        { key: 'duracion', text: 'Duración', itemType: DropdownMenuItemType.Header },
        { key: 'no', text: 'No tiene modo campaña.' },
        { key: '10a20', text: 'De 10 a 20 horas.' },
        { key: '20a30', text: 'De 20 a 30 horas.' },
        { key: '30a40', text: 'De 30 a 40 horas.' },
        { key: '40a50', text: 'De 40 a 50 horas.' },
        { key: '50a60', text: 'De 50 a 60 horas.' },
        { key: 'masde60', text: 'Más de 60 horas.' },
    ];
    //Creación de un selector de fechas para nuestro pop-up
    var firstDayOfWeek = React.useState(DayOfWeek.Sunday)[0];
    var stackTokens = { childrenGap: 20 };
    //Return de nuestro código.
    return (React.createElement("div", { className: styles.webpart1 },
        React.createElement(Button, { type: "primary", onClick: showModal }, "A\u00F1adir nuevo juego."),
        React.createElement(Modal, { title: "Datos del juego a a\u00F1adir", open: isModalOpen, onOk: handleOk, onCancel: handleCancel },
            React.createElement(Stack, { horizontal: true, tokens: stackTokens, styles: stackStyles },
                React.createElement(Stack, __assign({}, columnProps),
                    React.createElement(TextField, { label: "Nombre del juego.", required: true }),
                    React.createElement(TextField, { label: "Descripci\u00F3n.", multiline: true, rows: 3, required: true }),
                    React.createElement(Dropdown, { required: true, placeholder: "G\u00E9nero.", label: "G\u00E9nero del juego.", options: optionsgenero, styles: dropdownStyles }),
                    React.createElement(Dropdown, { required: true, placeholder: "Duraci\u00F3n.", label: "Duraci\u00F3n del modo campa\u00F1a.", options: optionsduracion, styles: dropdownStyles }),
                    React.createElement(DatePicker, { firstDayOfWeek: firstDayOfWeek, placeholder: "Selecciona fecha de salida.", ariaLabel: "Selecciona una fecha.", strings: defaultDatePickerStrings })))),
        React.createElement(Table, { dataSource: datos, columns: columns }),
        ";"));
}
//# sourceMappingURL=Webpart1.js.map