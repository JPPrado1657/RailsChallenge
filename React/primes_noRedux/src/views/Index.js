import React from "react";
import {
  Card,
  CardHeader,
  CardBody,
  Container,
  Row,
  Col,
  Form,
  FormGroup,
  Input,
  InputGroup,
  InputGroupAddon,
  InputGroupText,
  Button,
  Table,
  Alert
} from "reactstrap";
import axios from 'axios';


import Header from "components/Headers/Header.js";

class Index extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      number: undefined,
      output: undefined,
      kept: undefined,
      errors: false
    };
  }

  isPrime = num => {
    for(let i = 2, s = Math.sqrt(num); i <= s; i++)
        if(num % i === 0) return false; 
    return num > 1;
  }

  handleInput = async e => {
    if(e.key === 'Enter'){
      e.preventDefault();
      const value = e.target.value;
      if(this.isPrime(value)){
        console.log(value);
        const response = (await axios.get(`http://localhost:3001/systems/1/inputs/by_number/${value}`)).data;
        let out = response.data;
        this.setState({
          number: value,
          output: out,
          kept: response.kept,
          errors: false
        });
      } else {
        this.setState({
          number: undefined,
          output: undefined,
          kept: undefined,
          errors: true
        });
      }
      
    }
  };

  saveResponse = async e => {
    e.preventDefault();
    let out = JSON.stringify(this.state.output);
    out = out.replace('[', '{');
    out = out.replace(']', '}');
    let request = {
      input: this.state.number,
      output: out,
      validInput: true
    }
    await axios.post('http://localhost:3001/systems/1/inputs', request)
    .then(res => {
      this.setState({
        number: this.state.number,
        output: this.state.output,
        kept: true
      });
    });
  }

  buttonMaker = () => {
    if (this.state.kept == undefined) {
      return
    } else if (!this.state.kept) {
      return (<Button
          color="info"
          className="mt-5"
          onClick= {this.saveResponse}
        >
          Save this response
        </Button>
      )
    } else {
      return (<Button
          color="info"
          className="mt-5"
          onClick={e => e.preventDefault()}
          disabled
        >
          This is already in the database
        </Button>
      )
    }
  }
  
  delErrors = (e) => {
    e.preventDefault();
    this.setState({
      number: undefined,
      output: undefined,
      kept: undefined,
      errors: false
    });
  }

  errors = () => {
    if(this.state.errors){
      return (
        <Alert color="danger" onClick={this.delErrors}>
          <strong>This is not a prime number!</strong> Click here to clear this message!
        </Alert>
      )    
    }
    return
  }
  
  render() {
    return (
      <>
        <Header />
        {/* Page content */}
        <Container className="mt--7" fluid>
          <Row>
            <Col className="mb-5" xl="12">
            <Card className="shadow">
                <CardHeader className="bg-transparent">
                  <Row className="align-items-center">
                    <div className="col">
                      <h2 className="mb-0">Primes</h2>
                    </div>
                    <div className="col">
                      <Form className="navbar-search navbar-search form-inline d-none d-md-flex ml-lg-auto">
                        <FormGroup className="mb-0">
                          <InputGroup className="input-group-alternative">
                            <InputGroupAddon addonType="prepend">
                              <InputGroupText>
                                <i className="fas fa-search" />
                              </InputGroupText>
                            </InputGroupAddon>
                            <Input
                              onKeyDown={this.handleInput}
                              placeholder="Inserta un número primo"
                              type="number" 
                            />
                          </InputGroup>
                        </FormGroup>
                      </Form>
                    </div>
                  </Row>
                </CardHeader>
                <CardBody>
                <h1>{ this.state.number }</h1>
                <Table className="align-items-center table-flush" responsive>
                  <tbody>
                    <tr>
                      {this.state.output?.map((value, key) => {
                        return (
                          <td key={key}>{value}</td>
                        )
                      })}
                    </tr>
                  </tbody>
                </Table>
                {this.buttonMaker()}
                {this.errors()}
                </CardBody>
              </Card>
            </Col>
          </Row>
          </Container>
      </>
    );
  }
}

export default Index;
