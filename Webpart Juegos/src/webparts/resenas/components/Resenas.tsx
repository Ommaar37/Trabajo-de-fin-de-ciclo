import styles from './Resenas.module.scss';
import * as React from 'react';
import { WebPartContext } from "@microsoft/sp-webpart-base";
import { SPFI } from "@pnp/sp";
import { IList } from '@pnp/sp/lists';
import { useEffect, useRef, useState } from 'react';
import { Table } from 'antd';

//CREACIÓN DE LAS COLUMNAS PARA LA TABLA DE EVENTOS DEL JUEGO
const columns = [
  {
    title: 'Usuario',
    dataIndex: 'R_User',
    key: 'R_User',
  },
  {
    title: 'Reseña',
    dataIndex: 'R_Res',
    key: 'R_Res',
  },
];

export interface IResenasProps {
  description: string;
  isDarkTheme: boolean;
  environmentMessage: string;
  hasTeamsContext: boolean;
  userDisplayName: string;
  SP: SPFI;
  WebPartContext: WebPartContext;
}
export default function Resenas(props: IResenasProps) {

  //OBTENER ID DE LA URL
  const id = useRef<number>(null);
  const [datos , setDatos] = useState<any>(null);
  //const [item, setItem] = useState<any>(null);
  const params = useRef<URLSearchParams>();
  const [nombre, setNombre] = useState("");
  const [descripcion, setDescripcion] = useState(null);
  const [fecha, setFecha] = useState(null);
  const [genero, setGenero] = useState(null);
  const [duracion, setDuracion] = useState(null);



  useEffect(() => {
    params.current = new URLSearchParams(window.location.search);
    id.current = parseInt(params.current.get('jid'));
    cargarDatos();
  }, [])


  //COGER DATOS DE LA LISTA JUEGOS EN FUNCIÓN DE EL ID QUE SE LE PASE EN LA URL 
  const cargarDatos = async function () {

    var lista: IList = await props.SP.web.lists.getByTitle("Juegos")
    var juego = await lista.items.getById(id.current)();
    if (juego != null) {
      console.log(juego)
    }
    setNombre(juego.Title);
    setDescripcion(juego.J_Desc);
    setFecha(juego.J_Lanz);
    setGenero(juego.J_Gen);
    setDuracion(juego.J_Dur)
  }

  //COGER LAS RESEÑAS DEL JUEGO.
  React.useEffect(() => {
    cargarResenas();
  }, [])

  const cargarResenas = async function () {
    var lista: IList = await props.SP.web.lists.getByTitle("Resenas")
    var resenas = await lista.items.top(5000).select("*")();
    let filas = [];

    resenas.map((r: any) => {
      console.log(r.R_Juego);
      filas.push({
              'Title': r.Title,
              'R_User': r.R_User,
              'R_Res': r.R_Res
            });
            console.log(r.R_User);
    });
    setDatos(resenas);
  }

    return (
      <div className={styles.resenas}>
        <h1>Página con detalles y reseñas de los juegos de nuestra tabla: {id.current}</h1>
        <ul>
          <li>Nombre del juego: {nombre}</li>
          <li>Descripción del juego: {descripcion}</li>
          <li>Fecha de salida: {fecha}</li>
          <li>Género del juego: {genero}</li>
          <li>Duración del modo campaña: {duracion}</li>
        </ul>
      <Table dataSource={datos} columns={columns}>
      </Table>
      </div>
    );
}
