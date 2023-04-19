import * as React from 'react';
import { WebPartContext } from "@microsoft/sp-webpart-base";
import { SPFI } from "@pnp/sp";
import { Button, Modal, Table } from 'antd';
import { useState } from 'react';
import styles from "./Webpart1.module.scss"
import { TextField } from '@fluentui/react/lib/TextField';
import { IStackProps, IStackStyles, IStackTokens, Stack } from '@fluentui/react/lib/Stack';
import { Dropdown, DropdownMenuItemType, IDropdownStyles, IDropdownOption } from '@fluentui/react/lib/Dropdown';
import * as moment from "moment"
import { DateTimePicker, DateConvention} from "@pnp/spfx-controls-react/lib/DateTimePicker";

//Definición de las columnas y petición para extraer los datos de la misma.
const columns = [
  {
    title: 'Acciones',
    dataIndex: 'acciones',
    key: 'Title',
    render: () => {
      return (<a href="//Aquí va la ruta al la página de sharepoint donde se mostraran los datos en profundidad de cada juego">Ver</a>)
    }
  },
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
    render: (dateString: string) => moment(dateString).format('DD/MM/YYYY'),
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
interface JuegoItem {
  Title: string;
  J_Desc: string;
  J_Dur: string;
  J_Gen: string;
  J_Lanz: string;
}
export interface DataType {
  key: string;
  item: JuegoItem;
}

//Definición de los campos de interfaz por defecto de Sharepoint añadiendo SP y el WebPartContext
export interface IWebpart1Props {
  description: string;
  isDarkTheme: boolean;
  environmentMessage: string;
  hasTeamsContext: boolean;
  userDisplayName: string;
  SP: SPFI;
  WebPartContext: WebPartContext;
}
//Función para coger los datos de la lista ya creada de Sharepoint.
export default function HelloWorld(props: IWebpart1Props) {
  const [nombre, setNombre] = useState("");
  const [descripcion, setDescripcion] = useState(null);
  const [fecha, setFecha] = useState(null);
  const [genero, setGenero] = useState<IDropdownOption>(null);
  const [duracion, setDuracion] = useState(null);


  const [datos, setDatos] = React.useState<any>(null);

  React.useEffect(() => {
    cargarDatos();
  }, [])

  const cargarDatos = async function () {

    var lista: any = await props.SP.web.lists.getByTitle("Juegos")

    var juegos = await lista.items.top(5000).select("*")();

    let filas = [];

    juegos.map((j: any) => {
      filas.push({
        'Title': j.Title,
        'J_Dur': j.J_Dur,
        'J_Lanz ': j.J_Lanz,
        'J_Desc': j.J_Desc,
        'J_Gen': j.J_Gen
      })
      console.log(j.Title);
    })


    setDatos(juegos);
  }

  //Creación del pop-up del botón para añadir nuevos juegos a la lista
  const [isModalOpen, setIsModalOpen] = useState(false);

  const showModal = () => {
    setIsModalOpen(true);
  };
  
  const handleOk = async () => {
    setIsModalOpen(false);
   
    const fechaString = fecha.toISOString();
    alert(nombre+descripcion+fechaString+genero.text+duracion.text);
    console.log(fecha)
    console.log(fechaString)
    //Accion de guardar
    var item: any = {};
    item["Title"] = nombre;
    item["J_Desc"] = descripcion;
    item["J_Lanz"] = fechaString;
    item["J_Gen"] = genero.text;
    item["J_Dur"] = duracion.text;

    try {
      var lista: any = await props.SP.web.lists.getByTitle("Juegos")
      await lista.items.add(item);
    } catch (ex) {
      console.log(ex);
    }
  };

  const handleCancel = () => {
    setIsModalOpen(false);
  };

  //Creación de los campos de texto de nuestro pop-up
  const stackStyles: Partial<IStackStyles> = { root: { width: 650 } }

  const columnProps: Partial<IStackProps> = {
    tokens: { childrenGap: 15 },
    styles: { root: { width: 300 } },
  };

  //Creación de los 2 selectores de nuestro pop-up
  const dropdownStyles: Partial<IDropdownStyles> = {
    dropdown: { width: 300 },
  };
  const optionsgenero: IDropdownOption[] = [
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

  const optionsduracion: IDropdownOption[] = [
    { key: 'duracion', text: 'Duración', itemType: DropdownMenuItemType.Header },
    { key: 'no', text: 'No tiene modo campaña.' },
    { key: '10a20', text: 'De 10 a 20 horas.' },
    { key: '20a30', text: 'De 20 a 30 horas.' },
    { key: '30a40', text: 'De 30 a 40 horas.' },
    { key: '40a50', text: 'De 40 a 50 horas.' },
    { key: '50a60', text: 'De 50 a 60 horas.' },
    { key: 'masde60', text: 'Más de 60 horas.' },
  ];
  const stackTokens: IStackTokens = { childrenGap: 20 };

  //Return del código.
  return (
    <div className={styles.webpart1}>
      <Button className={styles.boton1} type="primary" onClick={showModal}>
        Añadir nuevo juego.
      </Button>
      <a href="PÁGINA DE EVENTOS">
      <Button className={styles.boton1} type="primary">
        Ver proximos eventos.
      </Button>
      </a>
      <Modal title="Datos del juego a añadir" open={isModalOpen} onOk={handleOk} onCancel={handleCancel}>
        <Stack horizontal tokens={stackTokens} styles={stackStyles}>
          <Stack {...columnProps}>
            <TextField value={nombre} onChange={(event, val) => setNombre(val)} label="Nombre del juego." required />
            <TextField value={descripcion} onChange={(event, val) => setDescripcion(val)} label="Descripción." multiline rows={3} required />
            <Dropdown
              placeholder="Género."
              label="Género del juego."
              selectedKey={genero?.key.toString()}
              onChange={(event, val) => setGenero(val)}
              options={optionsgenero}
              styles={dropdownStyles}
            />
            <Dropdown
              selectedKey={duracion?.key.toString()}
              onChange={(event, val) => setDuracion(val)}
              placeholder="Duración."
              label="Duración del modo campaña."
              options={optionsduracion}
              styles={dropdownStyles}
            />
            <DateTimePicker
              showLabels={false}
              label="Introduce fecha"
              firstDayOfWeek={1}
              value={fecha}
              dateConvention={DateConvention.Date}
              formatDate={(Date) => {
              if (Date == null) return null;
                return Date.toLocaleDateString();
              }}
              onChange={(Date) => {
                setFecha(Date);
              }}
              allowTextInput={false}
              showClearDate={true}
            ></DateTimePicker>
          </Stack>
        </Stack>
      </Modal>
      <Table dataSource={datos} columns={columns}>
      </Table>
    </div>
  )
}